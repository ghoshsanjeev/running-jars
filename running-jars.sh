#!/bin/sh

sudo netstat -ntlp |grep java | sed 1,2d > /tmp/output_netstat.txt

echo PORT$'\t'PID$'\t'NAME
for port in $(cat /tmp/output_netstat.txt | awk '{print $4 " " $7}' | sed -e 's/.*://' | awk '{print $1}' | uniq)
do
    pid=$(cat /tmp/output_netstat.txt | grep -w "$port" | awk '{print $7}' | cut -d ' ' -f 7 | cut -d '/' -f 1 | uniq )
    #ps_name=$(cat /tmp/output_netstat.txt | awk '{print $4 " " $7}' | sed -e 's/.*://' | sed 's/\// /g' | awk '{print $3}')
    ps_name=$(ps -ef | grep "$pid" |egrep -o "(\w*[-])+[0-9]+([.][0-9]+)+[-]*(SNAPSHOT)*[.]jar")
    #ps_name_output=$(ps -ef | grep "$pid" | grep "$ps_name" | grep -v grep |tr -s ' '| sed 's/^[^0-9]*//g' | head -1 | cut -f2- -d/)
    echo  "$port"$'\t'"$pid"$'\t'"$ps_name
done

rm -rf /tmp/output_netstat.txt
