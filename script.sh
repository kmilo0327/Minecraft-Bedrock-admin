#!/bin/bash
while :
do
clear
echo "###############################################################################"
echo "# Creado por kmilo0327 para la facilitacion de levantamiento de mundos        #"
echo "###############################################################################"
echo "#"
echo Bienvenid@ al administrador de servidores
echo ¿Que desea hacer?
echo "1) Agregar usuario"
echo "2) Iniciar Servicio"
echo "3) Detener servicio"
echo "4) Reiniciar Servicio"
echo "5) Estado del Servicio"
echo "9) Salir"
echo "************************************"
echo "8732) Eliminar usuario"
echo -n "Seleccionar una opcion: "
read opcion
case $opcion in

#This create an user to an specific folder
#Also make a systemd service, you can start, stop a restar the service from systemctl
#Note: You need to change all users "milo" for your own Linux user, i´m working on it

1) clear
echo "Agregar usuario";
echo -n "Escribe usuario:"
read usuario;
sudo apt install unzip -y
sudo mkdir -p /home/milo/minecraft/$usuario ;
sudo chown milo:milo /home/milo/minecraft/$usuario ;
sudo touch /lib/systemd/system/${usuario}.service ;
echo "
[Unit]
Description=$usuario Minecraft Service
After=network.target

[Service]
#Type=Simple
User=milo
WorkingDirectory=/home/milo/minecraft/$usuario/
ExecStart=/bin/sh -c 'LD_LIBRARY_PATH=. ./${usuario}_server '
Restart=on-failure

[Install]
WantedBy=multi-user.target " > /lib/systemd/system/${usuario}.service ;

sudo unzip bedrock-server-* -d /home/milo/minecraft/$usuario ;
sudo mv /home/milo/minecraft/$usuario/bedrock_server /home/milo/minecraft/$usuario/${usuario}_server
sudo rm -rf /home/milo/minecraft/$usuario/server.properties;
sudo touch /home/milo/minecraft/$usuario/server.properties;

#This section, make a rule on the firewall, the range of ports is between 10000 to 19999 and it is random number
#You need to allow this range port on your router.

clear
#echo -n "Numero de puerto: "
#read puerto;
puerto=$(shuf -i 10000-19999 -n 1)
puertov6=$((( $puerto ) + 10000 ))
echo -n "Dificultad, easy, normal, hard: "
read dificultad
echo -n "Numero de personas: "
read personas
echo -n "Semilla (Si no se especifica omitir): "
read semilla
sudo touch /home/milo/minecraft/$usuario/${usuario}.puerto.txt
sudo echo "$puerto" > /home/milo/minecraft/$usuario/${usuario}.puerto.txt
sudo ufw allow from any to 192.168.0.251 port $puerto

#This section make a unique config per minecraft service

echo "server-name=$usuario Server
gamemode=survival
difficulty=$dificultad
allow-cheats=false
max-players=$personas
online-mode=true
white-list=false

server-port=$puerto
server-portv6=$puertov6

view-distance=16

tick-distance=4
player-idle-timeout=30
max-threads=4
level-name=$usuario level


level-seed=$semilla

default-player-permission-level=member
# Allowed values: "visitor", "member", "operator"

texturepack-required=false
content-log-file-enabled=false
compression-threshold=1
server-authoritative-movement=server-auth
player-movement-score-threshold=20
player-movement-distance-threshold=0.3
player-movement-duration-threshold-in-ms=500
correct-player-movement=false " > /home/milo/minecraft/$usuario/server.properties ;

sudo systemctl enable ${usuario}.service
sudo systemctl start ${usuario}.service
sudo touch /home/milo/lista.txt
sudo echo "$usuario $puerto" >> /home/milo/lista.txt
clear
echo "Preparando servidor, espere"
sleep 10
echo "Preparando servidor, casi esta"
sleep 10
clear;
echo "**********Datos del servidor*******"
echo "*IP Servidor: juegatelag.tk       *"
echo "*puerto: $puerto                  *"
echo "***********************************"
read -p "Presiona una tecla para continuar"
echo "El servidor esta actualmente"
sudo systemctl status ${usuario}.service
read -p "Presiona una tecla para continuar"
exit ;;


2)clear
        echo "Iniciar Servicio"
        echo -n "Escribe usuario: "
        read usuario
        sudo systemctl enable ${usuario}.service
        sudo systemctl start ${usuario}.service
        sudo systemctl status ${usuario}.service
        exit;;

3)clear
        echo "Detener Servicio"
        echo -n "Escribe usuario: "
        read usuario
        sudo systemctl disable ${usuario}.service
        sudo systemctl stop ${usuario}.service
        sudo systemctl status ${usuario}.service
        exit;;

4)clear
        echo "Reiniciar Servicio"
        echo -n "Escribe usuario: "
        read usuario
        sudo systemctl restart ${usuario}.service
        sudo systemctl status ${usuario}.service
        exit;;

3)clear
        echo "Estado Servicio"
        echo -n "Escribe usuario: "
        read usuario
        sudo systemctl status ${usuario}.service
        exit;;

9)
clear
exit;;

8732)clear
echo "Asistente para eliminar usuario"
echo -n "Nombre del usuario: "
read usuario
read -p "¿Seguro?"
sudo systemctl disable $usuario.service
sudo systemctl stop ${usuario}.service
file="/home/milo/minecraft/$usuario/${usuario}.puerto.txt"
port=$(cat "$file")
echo "El puerto es $port"
sudo ufw deny from any to 192.168.0.251 port $port
sudo mkdir /home/milo/Respaldo/$usuario
sudo rm -rf /home/milo/Papelera$usuario
sudo mv -f /home/milo/minecraft/$usuario /home/milo/Respaldo/$usuario
sudo mv -f /lib/systemd/system/${usuario}.service /home/Respaldo/$usuario
echo "Datos eliminado"
read -p "Presiona para continuar" ;;

esac
done
