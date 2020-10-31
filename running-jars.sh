#!/bin/sh

sudo netstat -ntlp |grep java|tr -s " "|cut -d " " -f4,7|egrep -o "[0-9][0-9]+[[:space:]][0-9][0-9]+"|uniq > /tmp/netstat.out

#Not using the padding logic
#padlimit=20
#pad=$(printf '%*s' "$padlimit")
#pad=${pad// /-}
#padlength=10

printf '\n%6s %-40s%6s %6s  %-50s\n' "PORT" "NAME" "PID" "PPID" "PATH"
echo "------------------------------------------------------------------------------------------------------------------------"
for port in $(cat /tmp/netstat.out|awk '{print $1}')
do
    pid=$(cat /tmp/netstat.out |grep "$port"|cut -d ' ' -f2 )
    ppid=$(ps -p "$pid" -o ppid=)
    ps_name=$(ps -ef | grep "$pid" |egrep -o "(\w*[-]*)+([0-9]+([.][0-9]+)+)*[-]*(SNAPSHOT)*[.]jar")
    path=$(sudo pwdx "$pid"|cut -d ':' -f2)
    printf '%6d %-40s' "$port" "$ps_name"
    #printf '%*.*s' 0 $((padlength - ${#ps_name})) "$pad"
    printf '%6d %6d %-50s\n' "$pid" "$ppid" "$path"
    #echo  "$port"$'\t'"$ps_name"$'\t\t\t'"$path"
done
echo "------------------------------------------------------------------------------------------------------------------------"
echo
rm -rf /tmp/netstat.out
