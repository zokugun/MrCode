# powershell -ExecutionPolicy ByPass -File build_windows.ps1

$env:Path += ";C:\Program Files\Git\bin"

bash ./get_repo.sh

bash ./prepare.sh

Set-Location -ErrorAction Stop vscodium

$Env:SHOULD_BUILD = 'yes'
$Env:CI_BUILD = 'no'
$Env:CI_WINDOWS = 'True'
$Env:BUILDARCH = 'x64'

bash ./build.sh