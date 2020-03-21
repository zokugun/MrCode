Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y sudo
choco install -y hyper

choco install -y jq
choco install -y python2
choco install -y nvm
choco install -y sed

nvm install 12

npm i -g yarn

npm install --global windows-build-tools --vs2015


$env:Path += ";C:\Program Files\Git\bin"


