# crm-docker

Let's startup every client with a single command

## Must have

### Chocolatey

@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

### Packages

choco install -y docker
choco install -y docker-machine
choco install -y docker-machine-vmwareworkstation

## Steps that must be automated

### Set ENV

Once you specify the environment from setup.bat, that value must flow until docker-compose env file and replace both the names of nginx and node hostname and the folder they munt for the plugins, lucklily they have all the same name! but we have to rewrite it several times.

### Shared folder

Once you create your VM default, you must stop it, go to the VM vmx file and edit it manually by replacing those lines:

    sharedFolder0.present = "true"
    sharedFolder0.enabled = "true"
    sharedFolder0.readAccess = "true"
    sharedFolder0.writeAccess = "true"
    sharedFolder0.hostPath = "C:\Users\"
    sharedFolder0.guestName = "Users"
    sharedFolder0.expiration = "never"
    sharedFolder.maxNum = "1"

With those:

    sharedFolder0.present = "true"
    sharedFolder0.enabled = "true"
    sharedFolder0.readAccess = "true"
    sharedFolder0.writeAccess = "true"
    sharedFolder0.hostPath = "C:\Users\"
    sharedFolder0.guestName = "Users"
    sharedFolder0.expiration = "never"
    sharedFolder1.present = "true"
    sharedFolder1.enabled = "true"
    sharedFolder1.readAccess = "true"
    sharedFolder1.writeAccess = "true"
    sharedFolder1.hostPath = "DRIVE:\PATH\TO\ROOT\OF\ALL\YOUR\PROJECTS"
    sharedFolder1.guestName = "TB"
    sharedFolder1.expiration = "never"
    sharedFolder.maxNum = "2"

## Usage from Windows

Just launch `start.bat` from PowerShell and follow the instructions, if is a new client or a new installation it will take a while to clone, make npm install and build all the projects.

## Debugging

### SSH into VM

As I find Bash if much more powerful than batch or PowerShell, I suggesto opening a connection to the VM running the real containers, both to check if the mounted volume is there and to get informations about ip addresses or container statuses.

    docker-machine active
    docker machine inspect default

From here you can get the IP of the virtual machine we just setup (default is byu convention, if you use a different VM just replace it with your VM name)
Now log-in into the VM with Putty/Kitty/.. with the credentials and the IP you can get from the docker-machine inspection

### Containers

Now you can check the processes with one of the following commands

    ps aux
    docker ps

If you see your containers running you should be able to run commands on them. I.e. if you want to check the mounted partitions just dive a bit from here:

    docker exec node ls -lah /mnt/
    docker exec node ls -lah /home/node/app

# TODO

* Fix docker-compose volume definition from hardcoded to env dependant
* start.sh need a python file to create the proper crm.dev.json file
