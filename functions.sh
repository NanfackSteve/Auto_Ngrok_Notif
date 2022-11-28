#!/bin/bash

account_sid='AC110f745919950590585f599ee730b4f7'
auth_token='4ddc1b1865148ecc9b5c14c7d969db37'

available_number='+18655686002'
your_number='+237693736932'

link=''
green='\e[1;32m'
red='\e[1;31m'
blue='\e[1;34m'
yellow='\e[33m'
cian='\e[1;96m'
nc='\e[0m'

log_file=/home/sun/Documents/projets/Ngrok_Twilio/ngrok_twilio.log
internet_status='Unknow'

checkInternet() {

  echo -ne "\nCheck Network..\t"
  date=$(date +'%F %X')

  # Check if we have I @IP
  ping -qc 4 8.8.8.8 >/dev/null 2>&1

  if [ $? -eq 2 ]; then
    echo -ne "Not IP address ! \n" && echo -e "$(date +'%F %X') \tNo_IP_address \tError" >>$log_file
    return
  fi

  # Check Percent of Packet Loss
  percentLoss=$(ping -c 5 -q 8.8.8.8 | grep -oP '\d+(?=% packet loss)')

  if [ "$percentLoss" -lt 100 ]; then
    internet_status='OK'
    echo -ne " ${green}[ OK ]\n${nc}" && echo -e "$(date +'%F %X') \tCheck_Network \tOK" >>$log_file
  else
    internet_status='Fail'
    echo -ne " ${red}[ Fail ]\n${nc}" && echo -e "$(date +'%F %X') \tCheck_Network \tFail" >>$log_file
  fi

}

launch_Ngrok() {

  # Kill existing ngrok process
  ngrok_pid=$(ps -C ngrok -o pid=)
  if [ -n "$ngrok_pid" ]; then kill -9 "$ngrok_pid"; fi

  case "$protocol" in
  22)
    ngrok tcp 22 >/dev/null &
    sleep 3
    if [ "$(ps -C ngrok -o comm=)" == "ngrok" ]; then echo -e " ${green}[ OK ]${nc}"; fi
    echo -e "$(date +'%F %X') \tStart_Ngrok  \tOK" >>$log_file
    ;;

  80)
    ngrok http 80 >/dev/null &
    sleep 3
    if [ "$(ps -C ngrok -o comm=)" == "ngrok" ]; then echo -e " ${green}[ OK ]${nc}"; fi
    echo -e "$(date +'%F %X') \tStart_Ngrok  \tOK" >>$log_file
    ;;

  443)
    ngrok http 443 >/dev/null &
    sleep 3
    if [ "$(ps -C ngrok -o comm=)" == "ngrok" ]; then echo -e " ${green}[ OK ]${nc}"; fi
    echo -e "$(date +'%F %X') \tStart_Ngrok  \tOK" >>$log_file
    ;;

  *)
    echo -e " ${red}[ Error ] - Bad protocol${nc}\n"
    echo -e "$(date +'%F %X') \tStart_Ngrok \tError" >>$log_file
    exit 1
    ;;

  esac
}
