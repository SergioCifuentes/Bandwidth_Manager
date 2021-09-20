while read -r linea
do
    IFS='='
    read -a args <<< "$linea"
    if [ ${args[0]} == "MAC_1" ] && [ $3 == "MAC_1" ]; 
    	then MAC=${args[1]}; fi
    if [ ${args[0]} == "MAC_2" ] && [ $3 == "MAC_2" ]; 
    	then MAC=${args[1]}; fi
    if [ ${args[0]} == "MAC_3" ] && [ $3 == "MAC_3" ]; 
    	then MAC=${args[1]}; fi
done < ../confs/MAC-Usuarios

if [ $1 -eq 0 ]; then
    iptables -I FORWARD 1 -p icmp -m mac --mac-source $MAC -m time --timestart $4 --timestop $5 -j ACCEPT
    iptables -I FORWARD 1 -p icmp -m state --state RELATED,ESTABLISHED -m time --timestart $4 --timestop $5 -j ACCEPT
fi
if [ $1 -eq 1 ]; then
    iptables -I FORWARD 1 -p $2 -m mac --mac-source $MAC -m $2 --dport $6:$7 -m time --timestart $4 --timestop $5 -j ACCEPT
    iptables -I FORWARD 1 -p $2 -m state --state RELATED,ESTABLISHED -m $2 --sport $6:$7 -m time --timestart $4 --timestop $5 -j ACCEPT
fi
if [ $1 -eq 2 ]; then
    iptables -I FORWARD 1 -p $2 -m mac --mac-source $MAC -m $2 --dport $6 -m time --timestart $4 --timestop $5 -j ACCEPT
    iptables -I FORWARD 1 -p $2 -m state --state RELATED,ESTABLISHED -m $2 --sport $6 -m time --timestart $4 --timestop $5 -j ACCEPT
fi
