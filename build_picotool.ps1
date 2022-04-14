# This script generates a new build of the pico tool placing it inside the picotool folder
# Useful for including a prebuilt picotool within projects

# On Windows this script must be run within a VS Powershell Prompt (to ensure cmake and nmake can be found)

# Linux: sudo apt install build-essential pkg-config libusb-1.0-0-dev

# Clone of update the repo
if (!(Test-Path -Path "bin/pico_tool")) {
    git clone --recurse-submodules https://github.com/raspberrypi/picotool.git bin/pico_tool
}

if (!(Test-Path -Path "bin/pico_sdk")) {
    git clone --recurse-submodules https://github.com/raspberrypi/pico-sdk.git bin/pico_sdk
}

$Env:PICO_SDK_PATH = [IO.Path]::Combine((Get-Location), "bin", "pico_sdk") 

if ($IsWindows -or $ENV:OS) {
    $Env:LIBUSB_ROOT = [IO.Path]::Combine((Get-Location), "libusb") 
}

Set-Location "bin/pico_tool"

if (!(Test-Path -Path "build")) {
    New-Item -Name "build" -ItemType "directory"
}
    
Set-Location "build"

if ($IsWindows -or $ENV:OS) {
    cmake -DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles" ..
    nmake
    
    Copy-Item "picotool.exe"  -Destination "..\..\..\"
}
else {
    cmake -DCMAKE_BUILD_TYPE=Release ..
    make
}

Set-Location "../../.."
