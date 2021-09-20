#$1 minuto
#$2 hora
#$3 ancho de banda ($3 = 3Mbit)
#$4 dirección mac
#$5 si es dinamico o estático ($5 = "ceil <MAX-BW>Mbit" | $5 = "")

DEV=enp1s0

# 12:15
if [ $4=="MAC1" ]; then
    echo "/sbin/tc class change dev $DEV parent 1:1 classid 1:2 htb rate ${3}Kbit $5"| at $2:$1
    
fi
if [ $4=="MAC2" ]; then
    echo "/sbin/tc class change dev $DEV parent 1:1 classid 1:3 htb rate ${3}Kbit $5"| at $2:$1

fi
if [ $4=="MAC3" ]; then
    echo "/sbin/tc class change dev $DEV parent 1:1 classid 1:4 htb rate ${3}Kbit $5"| at $2:$1
fi
