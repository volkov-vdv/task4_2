#!/bin/bash
 
if [ -z "`pgrep ntp`" ]
then
    echo "NOTICE: ntp is not running"
    systemctl restart ntp
fi

x=`diff -U 0 /etc/ntp.conf $(dirname $(realpath $0))/ntp.conf_original`
if [ -n "$x" ]; then
#echo "$x"
echo -e "NOTICE: /etc/ntp.conf was changed. Calculated diff:\n$x"
cp $(dirname $(realpath $0))/ntp.conf_original /etc/ntp.conf
systemctl restart ntp

fi



