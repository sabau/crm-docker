#!/usr/bin/env bash

dev="/home/node/app/node-api/crm.dev.json"
if [ -f "$file" ]
then
	echo "$dev found."
else
	echo "Generating $dev"
    cp /home/node/app/node-api/crm.json /home/node/app/node-api/crm.dev.json
fi

cd /home/node/app/dafne-it && nohup build watch &
cd /home/node/app/crm-40 && nohup npm run watch &
cd /home/node/app/crm-40-modules && nohup npm run watch &
cd /home/node/app/node-api && npm run dev

# awk -F, 'NR==FNR{a[$1]=$0;next;}a[$1]{$0=a[$1]}1' /home/node/paths /home/node/app/node-api/crm.dev.json
