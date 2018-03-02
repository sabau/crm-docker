# crm-docker

Let's startup every client with a single command

## Must have

### chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

### Packages

choco install -y docker  
choco install -y docker-machine  
choco install -y docker-machine-vmwareworkstation  

## Steps that must be automated

### Set ENV

Once you specify the environemtn from start.bat, that value must flow until docker-compose env file and replace both the names of nginx and node hostname and the folder they munt for the plugins, lucklily they have all the same name!

### first time
docker-machine create -d vmwareworkstation default
docker-machine start | iex

### everyday
docker-machine start
docker-machine start | iex

## Usage

start.bat
docker-compose up

