#!/bin/bash

source /home/sun/Documents/projets/Ngrok_Twilio/functions.sh

# 0 - Chech args

if [ "$#" -gt 1 ]; then echo -e "\nMauvais usage du script !!\n" && exit 1; fi
protocol=22 && if [ "$#" -eq 1 ]; then protocol=$1; fi

# 1- Check Internet Access

checkInternet
while [ "$internet_status" != 'OK' ]; do
    sleep 5 && checkInternet
done

# 2- Laounch Ngrok Tunnel

echo -en "Ngrok Start....\t" && sleep 1
launch_Ngrok

# 3- Get Public Link

echo -en "Public Link....\t"
while [ -z "$link" ]; do
    sleep 2
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://.*.ngrok.io")
    if [ -z "$link" ]; then link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "tcp://.*.ngrok.io:[0-9]*"); fi
done

echo -e " ${cian}[ $link ]${nc}" && echo -e "$(date +'%F %X') \tGet_Pub_Link \tOK" >>$log_file

# 4- Send SMS

echo -ne "Send a NOTIF...\t"
# response=$(curl -s -X POST -d "Body=Link - ${link}" -d "From=${available_number}" -d "To=${your_number}" \
#     "https://api.twilio.com/2010-04-01/Accounts/${account_sid}/Messages" -u "${account_sid}:${auth_token}")
echo -e " ${green}[ OK ]${nc}\n" # && echo -e "\n$response\n"
