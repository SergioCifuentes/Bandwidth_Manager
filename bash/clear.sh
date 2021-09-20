iptables -F 
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
#Limpieza con tc
tc qdisc del dev enp1s0 root
#Limpieza de at
for i in `atq | awk '{print $1}'`;do atrm $i;done
echo "Limpieza terminada\n"
