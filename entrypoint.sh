#!/bin/bash

MyWait=10s # tiempo de espera en segundos para arrancar cada servicio
echo " " > /ayuda.txt
echo "El botón derecho del ratón abre un menú contextual que permite cerrar kill cada panel" >> /ayuda.txt
echo "El ratón  debe estar activo para cambiar entre estas ventanas, y para cambiar entre los paneles. " >> /ayuda.txt
echo "La siguiente orden activa el ratón." >> /ayuda.txt
echo "tmux set-option -g mouse on" >> /ayuda.txt
echo "Kafka está instalado en el directorio /kafka" >> /ayuda.txt
echo "El usuario linux es root y el password toor" >> /ayuda.txt

echo " " >> /ayuda.txt
echo "---Ventana wEstado----------------" >> /ayuda.txt
echo "----------------------------------" >> /ayuda.txt
echo "Panel superior izquierdo: configuración del conector source = nano /envia.properties" >> /ayuda.txt
echo "Panel superior derecho: configuración del conector source = nano /recibe.properties" >> /ayuda.txt
echo "Panel inferior izquierdo: htop información estado del servidor y procesos" >> /ayuda.txt
echo "Panel superior derecho: mc administrador de archivos " >> /ayuda.txt
echo " " >> /ayuda.txt
echo "---Ventana wServidores------------" >> /ayuda.txt
echo "----------------------------------" >> /ayuda.txt
echo "Panel superior izquierdo: servidor zookeeper /kafka/bin/zookeeper-server-start.sh" >> /ayuda.txt
echo "# /kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties"  >> /ayuda.txt
echo "Panel superior derecho: servidor kafka /kafka/bin/kafka-server-start.sh " >> /ayuda.txt
echo "# /kafka/bin/kafka-server-start.sh /kafka/config/server.properties" >> /ayuda.txt
echo "Panel inferior: /kafka/bin/connect-standalone.sh " >> /ayuda.txt
echo "# /kafka/bin/connect-standalone.sh /kafka/config/connect-standalone.properties /envia.properties /recibe.properties" >> /ayuda.txt
echo " " >> /ayuda.txt
echo "---Ventana wConectorArchivos------" >> /ayuda.txt
echo "----------------------------------" >> /ayuda.txt
echo "Cada nueva linea que insertes en el archivo /envia.txt (panel inferior) nano /ayuda.txt" >> /ayuda.txt
echo "Se publica en consola-consumer (panel superior izquierdo) /kafka/bin/kafka-console-consumer.sh" >> /ayuda.txt
echo "# /kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning" >> /ayuda.txt
echo "y se publica en el archivo /recibe.txt (panel superior derecho) tail -f /recibe.txt" >> /ayuda.txt
echo " " >> /ayuda.txt
echo "---Ventana wEscribirLeerEventos---" >> /ayuda.txt
echo "----------------------------------" >> /ayuda.txt
echo "En esta ventana de ayuda dispone de varios terminales donde probar https://kafka.apache.org/quickstart" >> /ayuda.txt
echo " * Paso 3: crea(create) un topic (tema) para almacenar tus eventos (describe, muestra información de uso):" >> /ayuda.txt
echo "bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092" >> /ayuda.txt
echo "bin/kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092" >> /ayuda.txt
echo " * Paso 4: Escriba algunos eventos en el topic (tema)" >> /ayuda.txt
echo "bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092" >> /ayuda.txt
echo "Escribir varias líneas ... " >> /ayuda.txt
echo "Para detener el cliente productor: Ctrl + C" >> /ayuda.txt
echo " * Paso 5: Lea los eventos" >> /ayuda.txt
echo "bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092" >> /ayuda.txt
echo "Para detener el cliente consumidor: Ctrl + C" >> /ayuda.txt
echo "---Ventana wAyuda-----------------" >> /ayuda.txt
echo "----------------------------------" >> /ayuda.txt
echo "Notas de ayuda ... " >> /ayuda.txt


# configuración de kafka
# https://kafka.apache.org/quickstart

echo "plugin.path=/kafka/libs/connect-file-3.2.0.jar" >> /kafka/config/connect-standalone.properties

echo "name=local-file-source" > /envia.properties
echo "connector.class=FileStreamSource" >> /envia.properties
echo "tasks.max=1" >> /envia.properties
echo "file=/envia.txt" >> /envia.properties
echo "topic=connect-test" >> /envia.properties

echo "name=local-file-sink" > /recibe.properties
echo "connector.class=FileStreamSink" >> /recibe.properties
echo "tasks.max=1" >> /recibe.properties
echo "file=/recibe.txt" >> /recibe.properties
echo "topics=connect-test" >> /recibe.properties

echo "Lo que añadas en el archivo /envia.txt se publica en consola-consumer y en archivo /recibe.txt" > /envia.txt
touch /recibe.txt

tmux start-server 

tmux new-session -d -s MyTmux1 -n wEstado -d "/usr/bin/env sh -c \"nano /envia.properties\"; /usr/bin/env sh -i"
tmux split-window -h -t MyTmux1:wEstado  nano /recibe.properties
tmux split-window -h -t MyTmux1:wEstado  htop
tmux split-window -v -t MyTmux1:wEstado  mc
tmux select-layout -t MyTmux1:wEstado tiled

echo "************Start the ZooKeeper service *********************************"  > /info.txt
echo "************exec -c /kafka/bin/zookeeper-server-start.sh config/zookeeper.properties *********************************" >> /info.txt
tmux new-window   -t MyTmux1 -n wServidores -d "/kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties" && sleep $MyWait 
echo "************Start the Kafka broker service *********************************"  >> /info.txt
echo "************exec -c /kafka/bin/kafka-server-start.sh config/server.properties *********************************"  >> /info.txt
tmux split-window -h -t MyTmux1:wServidores   "/kafka/bin/kafka-server-start.sh /kafka/config/server.properties"  && sleep $MyWait 
echo "************Start the Kafka consumer *********************************"  >> /info.txt
echo "************/kafka/bin/kafka-console-consumer.sh *********************************"  >> /info.txt
tmux split-window -v -t MyTmux1:wServidores "/kafka/bin/connect-standalone.sh /kafka/config/connect-standalone.properties /envia.properties /recibe.properties"  && sleep $MyWait
tmux select-layout -t MyTmux1:wServidores tiled

echo "************Start the Kafka connector *********************************"  >> /info.txt
echo "************/kafka/bin/connect-standalone.sh *********************************"  >> /info.txt
tmux new-window  -t MyTmux1 -n wConectorArchivos -d "/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning" && sleep $MyWait
tmux split-window -h -t MyTmux1:wConectorArchivos  "/usr/bin/env sh -c \"tail -f /recibe.txt\"; /usr/bin/env sh -i"
tmux split-window -h -t MyTmux1:wConectorArchivos  "/usr/bin/env sh -c \"nano /envia.txt\"; /usr/bin/env sh -i"
tmux select-layout -t MyTmux1:wConectorArchivos tiled


echo "************Start the Kafka connector *********************************"  >> /info.txt
echo "************/kafka/bin/connect-standalone.sh *********************************"  >> /info.txt
tmux new-window  -t MyTmux1 -n wEscribirLeerEventos -d "/usr/bin/env sh -c \"bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092\"; /usr/bin/env sh -i" 
tmux split-window -v -t MyTmux1:wEscribirLeerEventos  "/usr/bin/env sh -c \"bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092\"; /usr/bin/env sh -i" 
tmux split-window -v -t MyTmux1:wEscribirLeerEventos  "/usr/bin/env sh -c \"echo 'Pruebas paso3 '\";bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092; /usr/bin/env sh -i" 
tmux select-layout -t MyTmux1:wEscribirLeerEventos tiled

tmux new-window  -t MyTmux1 -n wAyuda -d  "/usr/bin/env sh -c \"cat /ayuda.txt\"; /usr/bin/env sh -i"
 
tmux set-option -g mouse on
tmux select-layout -t MyTmux1:wAyuda tiled

tmux attach-session -t MyTmux1:wAyuda
tmux attach-session -t MyTmux1:wConectorArchivos
tmux attach-session -t MyTmux1:wEstado
tmux attach-session -t MyTmux1:wServidores
tmux attach-session -t MyTmux1:wEscribirLeerEventos


