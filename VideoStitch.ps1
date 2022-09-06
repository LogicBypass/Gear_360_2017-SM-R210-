Write-Host "888                       d8b               888888b.                                                "
Write-Host "888                       Y8P               888  .88b                                               "
Write-Host "888                                         888  .88P                                               "
Write-Host "888      .d88b.   .d88b.  888  .d8888b      8888888K.  888  888 88888b.   8888b.  .d8888b  .d8888b  "
Write-Host "888     d88..88b d88P.88b 888 d88P.         888  .Y88b 888  888 888 .88b     .88b 88K      88K      "
Write-Host "888     888  888 888  888 888 888           888    888 888  888 888  888 .d888888 -Y8888b. -Y8888b. "
Write-Host "888     Y88..88P Y88b 888 888 Y88b.         888   d88P Y88b 888 888 d88P 888  888      X88      X88 "
Write-Host "88888888 -Y88P-   *Y88888 888  *Y8888P      8888888P*   *Y88888 88888P*  *Y888888  88888P*  88888P* "
Write-Host "                      888                                   888 888                                 "
Write-Host "                 Y8b d88P                              Y8b d88P 888                                 "
Write-Host "                  *Y88P*                                *Y88P*  888                                 "
Write-Host ""
Write-Host ""
Write-Host "Gear 360 Stitching Script"
Write-Host "https://github.com/LogicBypass/Gear_360_Stitch"
Write-Host ""
Write-Host ""
Start-Sleep 4

$scriptpath = $MyInvocation.MyCommand.Definition 
[string]$dir = Split-Path $scriptpath  
set-location $dir

$files = Get-ChildItem "360*.MP4"
$nr = 1

ffmpeg -f lavfi -i nullsrc=size=2048x2048 -vf "format=gray8,geq='clip(128-128/8*(180-195/(2048/2)*hypot(X-2048/2,Y-2048/2)),0,255)',v360=input=fisheye:output=e:ih_fov=195:iv_fov=194" -frames 1 -y mergeVmap.png
foreach ($f in $files){
    ffmpeg -hwaccel auto -i $f -i mergeVmap.png  -f lavfi -i color=black:s=2x2 -lavfi "[0]format=rgb24,split[a][b];
    [a]crop=ih:iw/2:0:0,v360=input=fisheye:output=e:ih_fov=195:iv_fov=194.2[c];
    [b]crop=ih:iw/2:iw/2:0,v360=fisheye:e:yaw=180:ih_fov=195:iv_fov=194.2[d];
    [1]format=gbrp[e];[c][d][e]maskedmerge,overlay=shortest=1" -qp 13 -b:v 30M -b:a 192k -r 24 -y V.Out$nr.MP4
    $nr++}
