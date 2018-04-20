echo off

set /p DRIVE="Enter the DRIVE where to clone all the CRM 4.0 repositories:"
set /p DIR="Enter the PATH where to clone all the CRM 4.0 repositories:"
set /p CODE="client code (DEFAULT: dafne-it ...):"

IF NOT DEFINED CODE SET CODE="dafne-it"
IF %CODE%=="" SET CODE="dafne-it"

IF NOT DEFINED DRIVE SET DRIVE=%~d0
IF %DRIVE%=="" SET DRIVE=%~d0

IF NOT DEFINED DIR SET DIR=%~p0
IF %DIR%=="" SET DIR=%~p0
echo %DRIVE%%DIR%
IF NOT EXIST %DRIVE%%DIR% GOTO NOWINDIR

echo %DRIVE%%DIR%
%DRIVE%
cd %DIR%

IF NOT EXIST %DRIVE%%DIR%\attachments mkdir attachments
IF NOT EXIST %DRIVE%%DIR%\versions mkdir versions

IF NOT EXIST %DRIVE%%DIR%\crm-40 (
  echo "Cloning crm-40"
  git clone http://devlab.trueblue.it/tbcrm-40/crm-40.git
  echo "Installing and building crm-40"
  start /separate /wait cmd /c "git pull && npm install && npm run build" &
) ELSE (
  echo "OK crm-40"
)

IF NOT EXIST %DRIVE%%DIR%\node-api (
  echo "Cloning node-api"
  git clone http://devlab.trueblue.it/tbcrm-40/node-api.git
  echo "Installing node-api"
  start /separate /wait cmd /c "git pull && npm install" &
) ELSE (
  echo "OK node-api"
)

IF NOT EXIST %DRIVE%%DIR%\crm-40-modules (
  echo "Cloning crm-40-modules"
  git clone http://devlab.trueblue.it/tbcrm-40/crm-40-modules.git
  echo "Installing and building crm-40-modules"
  start /separate /wait cmd /c "git pull && npm install && npm run build" &
) ELSE (
  echo "OK modules"
)

IF NOT EXIST %DRIVE%%DIR%\%CODE% (
  echo "Cloning and building plugins"
  git clone http://devlab.trueblue.it/tbcrm-40/%CODE%.git
  echo "Installing and building plugins"
  start /separate /wait cmd /c "git pull && npm install && build build" &
) ELSE (
  echo "OK plugins"
)

:: we need that check working
:: docker-machine ls | find /i "default"
::IF %ERRORLEVEL% NEQ 0 (
  :: here I suggest making a link to the .docker folder pointing to a different hard disk, to avoid fill C: with shit
  docker-machine --native-ssh create -d vmwareworkstation default
  :: sorry I have not time to fix vmx file for every docker version
  :: you have shut it down, edit A:\docker\machine\machines\default\default.vmx
  :: sharedFolder0.present = "true"
  :: sharedFolder0.enabled = "true"
  :: sharedFolder0.readAccess = "true"
  :: sharedFolder0.writeAccess = "true"
  :: sharedFolder0.hostPath = "C:\Users\"
  :: sharedFolder0.guestName = "Users"
  :: sharedFolder0.expiration = "never"
  :: sharedFolder1.present = "true"
  :: sharedFolder1.enabled = "true"
  :: sharedFolder1.readAccess = "true"
  :: sharedFolder1.writeAccess = "true"
  :: sharedFolder1.hostPath = "A:\"
  :: sharedFolder1.guestName = "TB"
  :: sharedFolder1.expiration = "never"
  :: sharedFolder.maxNum = "2"
:: )
docker-machine start
FOR /f "tokens=*" %%i IN ('docker-machine env default') DO %%i
:: docker-machine env | iex
:: docker-compose rm --all && docker-compose pull &&
docker-compose build --no-cache
docker-compose up

:NOWINDIR