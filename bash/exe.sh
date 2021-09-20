#LEYENDO EL ARCHIVO DE TEXTO ENLACE.CONF------------------------------------------------------
echo "MANEJADOR DE ANCHO DE BANDA"
while true
do
    options=("Limpiar iptables y at jobs" "Instalar herramientas- crear nodos htb"
         "Programar BW y Proto" "Manual de configuraciones" "Salir")
    select opt in "${options[@]}"
    do
        case $opt in
            "Limpiar iptables y at jobs") ./clear.sh
            break;;
            "Instalar herramientas- crear nodos htb") ./create-nodes.sh
            break;;
            "Programar BW y Proto") ./exe2.sh
            break;;
            "Manual de configuraciones") ./manual.sh 
            break;;
    	    "Salir") exit ;;
    	    *) echo "Opcion Invalido";;
        esac
   done
done
