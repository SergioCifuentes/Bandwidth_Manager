if ! command -v iptables &> /dev/null 
then echo "ERROR: DEBES INSTALAR iptables"
    exit
fi
if ! command -v tc &> /dev/null
then echo "ERROR: DEBES INSTALAR Traffic Control (tc)"
    exit
fi	
if ! command -v at &> /dev/null
then echo "ERROR: DEBES INSTALAR at"
    exit
fi
iptables -P INPUT DROP 
iptables -P FORWARD DROP
iptables -P OUTPUT DROP	
DEV=enp1s0

while read -r linea
do
    IFS='='
    read -a parametros <<< "$linea"
    if [ ${parametros[0]} == "MAC_1" ]; 
       then MAC_1=${parametros[1]}; fi
    if [ ${parametros[0]} == "MAC_2" ]; 
        then MAC_2=${parametros[1]}; fi
    if [ ${parametros[0]} == "MAC_3" ]; 
        then MAC_3=${parametros[1]}; fi
done < ../confs/MAC-Usuarios



insmod sch_htb 2> /dev/null

#NODO RAIZ id: 1:1
tc qdisc add dev $DEV root handle 1: htb default 0xA


filter_mac() {

    M0=$(echo $1 | cut -d : -f 1)$(echo $1 | cut -d : -f 2)
    M1=$(echo $1 | cut -d : -f 3)$(echo $1 | cut -d : -f 4)
    M2=$(echo $1 | cut -d : -f 5)$(echo $1 | cut -d : -f 6)
tc filter add dev $DEV parent 1: protocol ip prio 5 u32 match u16 0x0800 0xFFFF at -2 match u16 0x${M2} 0xFFFF at -4 match u32 0x${M0}${M1} 0xFFFFFFFF at -8 flowid $2 
tc filter add dev $DEV parent 1: protocol ip prio 5 u32 match u16 0x0800 0xFFFF at -2 match u32 0x${M1}${M2} 0xFFFFFFFF at -12 match u16 0x${M0} 0xFFFF at -14 flowid $2
}
#NODO HIJO id: 1:2
tc class add dev $DEV parent 1:1 classid 1:2 htb rate 1Kbit
#NODO HIJO id: 1:3
tc class add dev $DEV parent 1:1 classid 1:3 htb rate 1Kbit
#NODO HIJO id: 1:4
tc class add dev $DEV parent 1:1 classid 1:4 htb rate 1Kbit

filter_mac $MAC_1 1:2
filter_mac $MAC_2 1:3
filter_mac $MAC_3 1:4

echo "=======Todo se instalo y los nodos se crearon====="
tc -s -d class show dev $DEV
