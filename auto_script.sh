#!/bin/bash
path=$HOME/Documents/projets/Auto_Ngrok_Notif
source $path/functions.sh

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

# 4- Notifications

echo -ne "Send an Email..\t" # Using EMAIL
python3 -c "import yagmail; yagmail.SMTP(user='237programmer', oauth2_file='${path}/credentials.json').send(to='nanfacksteve7@gmail.com', subject='Ngrok Link', contents='${link}', attachments='${path}/ngrok_twilio.log')" 2>/dev/null
if [ $? -eq 0 ]; then echo -e " ${green}[ OK ]${nc}\n" && echo -e "$(date +'%F %X') \tSend_Email  \tOK" >>$log_file; else echo -e " ${red}[ Fail ]${nc}\n" && echo -e "$(date +'%F %X') \tSend_Email  \tFail" >>$log_file; fi
