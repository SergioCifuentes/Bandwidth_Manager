echo "enlace.conf"
while read -r linea
do
    IFS='='
    read -a args <<< "$linea"
    if [ ${args[0]} == "down" ]; 
        then BW_Down=${args[1]}; fi 
    if [ ${args[0]} == "up" ]; 
        then BW_Up=${args[1]}; fi 
done < ../confs/enlace.conf
((BWG=(BW_Down+BW_Up)*1024)) 
echo "El ancho de banda total es de: ${BWG}Kbit"
echo

echo "     MODO.CONF    "
while read -r linea
do
    IFS='='
    read -a args <<< "$linea"
    MODE=${args[1]}
done < ../confs/modo.conf
if [ $MODE -eq 1 ]; then echo "El modo de configuración es estricto."; fi
if [ $MODE -eq 2 ]; then echo "El modo de configuración es dinámico."; fi
echo

echo "	usuario-BW.conf    "
if [ $MODE -eq 2 ]; 
    then CEIL="ceil ${BWG}Kbit"; fi 
    
while read -r linea
do
  #args:
  #[1]mac, [2] up, [3] down, [4] start_time, [5] end time
    IFS=','
    read -a args <<< "$linea"
    #ancho de banda de bajada(%)
    BW_DownT=${args[1]}; 
    #ancho de banda de subida(%)
    BW_UpT=${args[2]};
    ((BWTT=(BW_Down*1024*BW_DownT/100)+(BW_Up*1024*BW_UpT/100)))
    IFS=":"
    read -a start_time <<< "${args[3]}" 
    read -a end_time <<< "${args[4]}"
    IFS=""
    	#Job de inicio
    ./at-job.sh ${start_time[1]} ${start_time[0]} $BWTT ${args[0]} $CEIL
        #Job al terminar
    ./at-job.sh ${end_time[1]} ${end_time[0]} 0 ${args[0]}
done < ../confs/usuario_BW.conf
echo

echo "	usuario-Prot.conf	"
while read -r linea
do
  #args:
  #[1]mac, [2] protocolo, [3] puerto, [4] start_time, [5] end time
    IFS=','
    read -a args <<< "$linea"
    if [ ${#args[@]} -eq 4 ]; then
      ./iptable.sh 0 icmp ${args[0]} ${args[2]} ${args[3]}
    fi

    if [ ${#args[@]} -eq 5 ]; then
      IFS=':'
      read -a puertos <<< "${args[2]}"
      IFS=""
      if [ ${#puertos[@]} -eq 2 ]; then
        ./iptable.sh 1 ${args[1]} ${args[0]} ${args[3]} ${args[4]} ${puertos[0]} ${puertos[1]}
      else 
        ./iptable.sh 1 ${args[1]} ${args[0]} ${args[3]} ${args[4]} ${args[2]}
      fi

    fi
done < ../confs/usuario_Proto.conf
echo
