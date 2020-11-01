#!/bin/sh

out=.netstat.out
sudo netstat -ntlp |grep java|tr -s " "|cut -d " " -f4,7|egrep -o "[0-9][0-9]+[[:space:]][0-9][0-9]+"|uniq > $out

#Not using the padding logic
#padlimit=20
#pad=$(printf '%*s' "$padlimit")
#pad=${pad// /-}
#padlength=10

printf '\n%6s %-45s%6s %6s %7s %5s  %-50s\n' "PORT" "NAME" "PID" "PPID" "RAM" "%MEM" "PATH"
hr="-----------------------------------------------------------------------------------------------------------------------------------"
echo "$hr"
for port in $(cat $out|awk '{print $1}')
do
    pid=$(cat $out |grep "$port"|cut -d ' ' -f2 )
    top=($(top -p $pid -b1 -n1|tail -1|tr -s ' '| sed -e 's/^[ \t]*//'|cut -d ' ' -f6,10))
    ram=${top[0]}
    (($ram)) 2>/dev/null
    if [[ $? -eq 0 ]]
    then
	ram=$(echo "scale=2; $ram/1024"|bc)m
    fi
    pmem=${top[1]}    
    ppid=$(ps -p $pid -o ppid=)
    ps_name=$(ps -ef | grep "$pid" |egrep -o "(\w*[-]*)+([0-9]+([.][0-9]+)+)*[-]*(SNAPSHOT)*[.]jar")
    path=$(sudo pwdx "$pid"|cut -d ':' -f2)
    printf '%6d %-45s' "$port" "$ps_name"
    #printf '%*.*s' 0 $((padlength - ${#ps_name})) "$pad"
    printf '%6d %6d %7s %5s %-50s\n' "$pid" "$ppid" "$ram" "$pmem" "$path"
    #echo  "$port"$'\t'"$ps_name"$'\t\t\t'"$path"
done
echo "$hr"
echo
rm -f $out
