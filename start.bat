echo off

set /p DRIVE="Enter the DRIVE where to clone all the CRM 4.0 repositories( A:\ ):"
set /p DIR="Enter the PATH where to clone all the CRM 4.0 repositories (\this\is\a\path):"
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
) ELSE (
  echo "OK crm-40"
)

IF NOT EXIST %DRIVE%%DIR%\node-api (
  echo "Cloning node-api"
  git clone http://devlab.trueblue.it/tbcrm-40/node-api.git
) ELSE (
  echo "OK node-api"
)

IF NOT EXIST %DRIVE%%DIR%\crm-40-modules (
  echo "Cloning crm-40-modules"
  git clone http://devlab.trueblue.it/tbcrm-40/crm-40-modules.git
) ELSE (
  echo "OK modules"
)

IF NOT EXIST %DRIVE%%DIR%\%CODE% (
  echo "Cloning plugins"
  git clone http://devlab.trueblue.it/tbcrm-40/%CODE%.git
) ELSE (
  echo "OK plugins"
)

call nvm install 8.9.4
call nvm use 8.9.4
start /separate /wait cmd /c "npm install -g gulp gulp-cli" &

cd crm-40
echo "install and build CRM 40"
start /separate /wait cmd /c "git pull && npm install && npm run build" &
cd ..

cd crm-40-modules
echo "install and build modules"
start /separate /wait cmd /c "git pull && npm install && npm run build" &
cd ..

cd %CODE%
echo "install and build plugin"
start /separate /wait cmd /c "git pull && npm install && npm run build" &
cd ..

cd node-api
echo "install and run API"
start /separate /wait cmd /c "git pull && npm install" &
cd ..


:NOWINDIR
