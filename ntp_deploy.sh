#!/bin/bash
I=`dpkg -s ntp | grep "Status" |awk '{print $2}' ` #проверяем состояние пакета (dpkg) и ищем в выводе его статус (grep)
if  [ -z "$I" -o "$I" == "deinstall" ] #проверяем что нашли строку со статусом (что строка не пуста)
then
   echo "ntp not installed"
   dpkg --purge ntp 2>/dev/null
   apt-get update
   apt-get -y install ntp
   sed -i '/^pool*/d' /etc/ntp.conf && echo "pool ua.pool.ntp.org iburst" >> /etc/ntp.conf
   systemctl restart ntp
   SOME_PID=$$
   p1=`lsof -p $SOME_PID |grep $0 |awk '{ print $9 }'| sed 's/ntp_deploy.sh/ntp_verify.sh/'`
   echo "*/1 * * * *   root    /bin/bash $p1" >> /etc/crontab
   cp /etc/ntp.conf $(dirname $(realpath $0))/ntp.conf_original		

else
    echo "ntp installed"
fi
