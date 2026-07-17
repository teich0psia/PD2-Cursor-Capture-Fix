param([string]$BuildDirectory = "build")
$Root = Split-Path -Parent $PSScriptRoot
$Dll = Join-Path $Root "$BuildDirectory/Release/pd2_cursor_capture.dll"
$Stage = Join-Path $Root "dist/stage"
$Out = Join-Path $Root "dist/PD2-Cursor-Capture-Fix.zip"
Remove-Item $Stage -Recurse -Force -ErrorAction SilentlyContinue
New-Item (Join-Path $Stage "native") -ItemType Directory -Force | Out-Null
Copy-Item "$Root/packaging/mod/mod.txt","$Root/packaging/mod/supermod.xml","$Root/README.md","$Root/README.ja.md","$Root/CHANGELOG.md","$Root/LICENSE" $Stage
Copy-Item $Dll (Join-Path $Stage "native/pd2_cursor_capture.dll")
New-Item (Split-Path $Out) -ItemType Directory -Force | Out-Null
Compress-Archive -Path (Join-Path $Stage "*") -DestinationPath $Out -Force
Write-Host "Packaged $Out"
