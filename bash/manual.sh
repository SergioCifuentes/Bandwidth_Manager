cat<<EOF

======================================================
Manual de Configuraciones
-enclace.conf-
En este arvhivo escribimos la velodidad de bajada y de subida de la siguiete manera en MBps:
'down=5
up=1'

-MAC-Usuario-
En este archivo escribimos las MAC de los usuarios conectados:
'MAC_1=52:54:00:02:1d:d2'

-modo.conf-
En este archivo escribimos la modalidad del ancho de banda en donde 1 es estatico y 0 es variable
'modalidad=1'

-usuario_BW.conf-
Aqui escribimos el ancho de banda que se le va limitar a cada usuario(MAC, subida, bajada, tiempo_inicial, tiempo final)
MAC1,10,20,01:00,2:00

-usuario_Proto.conf-
Aqui escribimos el protocolo y puerto que se le va limitar a cada usuario(MAC, protocolo, puerto, tiempo_inicial, tiempo final)
MAC1,tcp,8,1:00,02:00


======================================================

EOF
