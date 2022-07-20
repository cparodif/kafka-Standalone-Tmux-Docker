# kafka-Standalone-Tmux-Docker
Probar Apache Kafka Standalone, utilizando ventanas Tmux, y Docker 


# kafka-Standalone-Docker-Tmux
Probar Apache Kafka Standalone utilizando Docker y tmux.

## 1. Instala y empieza a utilizar kafka-Standalone-Docker-Tmux

Cambia a tu carpeta de Descargas (por ejemplo), y clona https://github.com/cparodif/kafka-Standalone-Docker-Tmux.git
```
cd Descargas
git clone https://github.com/cparodif/kafka-Standalone-Docker-Tmux.git
cd  kafka-Standalone-Docker-Tmux
sudo su
docker build . -t kafka
docker run -it -p 9092:9092 -p 2181:2181  kafka
```
En poco más de 40 segundos debe aparecer la ventana de ayuda, fijate en la barra de estado en la zona inferior. Verás los nombres de las ventanas disponibles. Haz clic con el ratón en cada uno de ellos y podrás ver e interactuar en los paneles y con el contenido de cada ventana. 

Puedes cerrar cada ventana haciendo **clic con el botón derecho del ratón en el nombre de cada ventana en la barra de estado** y sin soltar seleccionar **kill**. La última ventana en cerrar debería ser wServidores.

## 2. Lo que te vas a encontrar  

La aplicación tmux dispone de una barra de  estado en la zona inferior. En nuestra sesión tmux, en la barra de estado aparecen los nombre de las cinco ventanas: wEstado wServidores wConectorArchivos wEscribirLeerEventos wAyuda. Cada ventana dispone de varios paneles. Cada panel puede tener una aplicación ejecutándose.

El botón derecho del ratón abre un menú contextual que permite cerrar kill cada panel. El ratón  debe estar activo para cambiar entre las ventana, y para cambiar entre los paneles.  La siguiente orden activa el ratón.
```
tmux set-option -g mouse on
```
Los datos no son persistentes. Cada vez que reinicie, se reconfiguran todo de nuevo. Kafka está instalado en el directorio /kafka. El archivo /entrypoint.sh se ejecuta al inicio y abre las ventanas y aplicaciones. El usuario linux es root y el password toor

#### Ventana wEstado (informativa)

1. Panel superior izquierdo: configuración del conector source = nano /envia.properties

2. Panel superior derecho: configuración del conector source = nano /recibe.properties

3. Panel inferior izquierdo: htop información estado del servidor y procesos

4. Panel superior derecho: mc administrador de archivos 

#### Ventana wServidores (informativa)

5. Panel superior izquierdo: servidor zookeeper /kafka/bin/zookeeper-server-start.sh
```
# /kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties
```
6. Panel superior derecho: servidor kafka /kafka/bin/kafka-server-start.sh 
```
# /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
```
7. Panel inferior: /kafka/bin/connect-standalone.sh 
```
# /kafka/bin/connect-standalone.sh /kafka/config/connect-standalone.properties /envia.properties /recibe.properties
``` 
#### Ventana wConectorArchivos (panel inferior es interactivo)
 
8. Panel inferior, nano /envia.txt: Donde insertar nuevas linea en el archivo /envia.txt.  

Puede escribir varias líneas y guardar el archivo /envia.txt mediante Ctrl + o (letra o) ya que está editando el archivo con nano.

9. Panel superior izquierdo, /kafka/bin/kafka-console-consumer.sh La consola-consumer donde se muestran los nuevos registros
``` 
# /kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning
```
10. Panel superior derecho, tail -f /recibe.txt donde se muestra el contenido del archivo /recibe.txt 

#### Ventana wEscribirLeerEventos (panel superior izquierdo es interactivo)

Haz clic en el panel superior izquierdo, escribe varias líneas, terminando con retorno de carro cada párrafo. Esta información debe aparecer automáticamente en el panel superior derecho.  

En esta ventana de ayuda dispone de varios terminales donde probar https://kafka.apache.org/quickstart

- Paso 4: Escriba algunos eventos en el topic (tema)
```
bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
Escribir varias líneas ... 
```
Para detener el cliente productor: Ctrl + C

- Paso 5: Lea los eventos
```
bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
```
Para detener el cliente consumidor: Ctrl + C

- Paso 3: crea(create) un topic (tema) para almacenar tus eventos (describe, muestra información de uso)
```
bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
y
bin/kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092
```


#### Ventana wAyuda (informativa)
Notas sobre las aplicaciones en funcionamiento.



## 3. Traducción de https://kafka.apache.org/quickstart

### Inicio rápido de Apache Kafka

¿Qué es Apache Kafka®? https://youtu.be/FKgi3n-FyNU

¿Está interesado en comenzar con Kafka? Siga las instrucciones de esta guía de inicio rápido o mire el video a continuación
https://youtu.be/FKgi3n-FyNU

[![What is Apache Kafka®?](http://img.youtube.com/vi/FKgi3n-FyNU/0.jpg)](http://www.youtube.com/watch?v=FKgi3n-FyNU "Qué es Apache Kafka - What is Apache Kafka®?")

#### Paso 1: Obtener Kafka

[Descargue](https://www.apache.org/dyn/closer.cgi?path=/kafka/3.2.0/kafka_2.13-3.2.0.tgz) la última versión de Kafka y extráigala: 
```
$ tar -xzf kafka_2.13-3.2.0.tgz
$ cd kafka_2.13-3.2.0
```

#### Paso 2: Inicie el entorno de Kafka

*NOTA: Su entorno local debe tener instalado Java 8+.*

Ejecute los siguientes comandos para iniciar todos los servicios en el orden correcto: 
```
# Inicie el servicio ZooKeeper
# Nota: Pronto, Apache Kafka ya no requerirá ZooKeeper.
$ bin/zookeeper-server-start.sh config/zookeeper.properties
```
Abra otra sesión de terminal y ejecute: 
```
# Inicie el servicio de broker (intermediario) de Kafka 
$ bin/kafka-server-start.sh config/server.properties
```
Una vez que todos los servicios se hayan iniciado correctamente, tendrá un entorno Kafka básico ejecutándose y listo para usar. 

#### Paso 3: crea un topic (tema) para almacenar tus eventos

Kafka es una plataforma de transmisión de eventos distribuidos que le permite leer, escribir, almacenar y procesar [eventos](https://kafka.apache.org/documentation/#messages) (también llamados registros o mensajes en la documentación) en muchas máquinas.

Los eventos de ejemplo son transacciones de pago, actualizaciones de geolocalización desde teléfonos móviles, pedidos de envío, mediciones de sensores de dispositivos IoT o equipos médicos, y mucho más. Estos eventos se organizan y almacenan en [topics(temas)](https://kafka.apache.org/documentation/#intro_concepts_and_terms) . Muy simplificado, un topic es similar a una carpeta en un sistema de archivos, y los eventos son los archivos en esa carpeta.

Entonces, antes de que puedas escribir tus primeros eventos, debes crear un topic. Abra otra sesión de terminal y ejecute: 


```
$ bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
```
Todas las herramientas de línea de comandos de Kafka tienen opciones adicionales: ejecute el comando **kafka-topics.sh** sin argumentos para mostrar información de uso. Por ejemplo, también puede mostrarle detalles como el [recuento de particiones](https://kafka.apache.org/documentation/#intro_concepts_and_terms) del nuevo topic:

```
$ bin/kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092
Topic:quickstart-events  PartitionCount:1    ReplicationFactor:1 Configs:
    Topic: quickstart-events Partition: 0    Leader: 0   Replicas: 0 Isr: 0
```
#### Paso 4: Escriba algunos eventos en el topic (tema)
Un cliente de Kafka se comunica con los agentes de Kafka a través de la red para escribir (o leer) eventos. Una vez recibidos, los intermediarios almacenarán los eventos de manera duradera y tolerante a errores durante el tiempo que necesite, incluso para siempre.

Ejecute el cliente productor de la consola para escribir algunos eventos en su tema. De manera predeterminada, cada línea que ingrese generará un evento separado que se escribirá en el topic(tema).
```
$ bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
This is my first event
This is my second event
```
Puede detener el cliente productor Ctrl-C en cualquier momento. 

#### Paso 5: Lea los eventos

Abra otra sesión de terminal y ejecute el cliente consumidor de la consola para leer los eventos que acaba de crear:
```
$ bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
This is my first event
This is my second event
```
Puede detener el cliente consumidor Ctrl-C en cualquier momento.

Siéntase libre de experimentar: por ejemplo, vuelva a su terminal de productor (paso anterior) para escribir eventos adicionales y vea cómo los eventos aparecen inmediatamente en su terminal de consumidor.

Debido a que los eventos se almacenan de forma duradera en Kafka, pueden ser leídos tantas veces y por tantos consumidores como desee. Puede verificar esto fácilmente abriendo otra sesión de terminal y volviendo a ejecutar el comando anterior.

#### Paso 6: Importe/exporte sus datos como secuencias de eventos con Kafka Connect

Probablemente tenga muchos datos en sistemas existentes, como bases de datos relacionales o sistemas de mensajería tradicionales, junto con muchas aplicaciones que ya usan estos sistemas. [Kafka Connect](https://kafka.apache.org/documentation/#connect) le permite ingerir continuamente datos de sistemas externos en Kafka y viceversa. Es una herramienta extensible que ejecuta conectores , que implementan la lógica personalizada para interactuar con un sistema externo. Por lo tanto, es muy fácil integrar los sistemas existentes con Kafka. Para facilitar aún más este proceso, hay cientos de estos conectores disponibles.

En este inicio rápido, veremos cómo ejecutar Kafka Connect con conectores simples que importan datos de un archivo a un tema de Kafka y exportan datos de un tema de Kafka a un archivo.

Primero, asegúrese de agregar connect-file-3.2.0.jara a la propiedad plugin.path  en la configuración del trabajador de Connect. A los fines de este inicio rápido, usaremos una ruta relativa y consideraremos el paquete de los conectores como un "uber jar", que funciona cuando los comandos de inicio rápido se ejecutan desde el directorio de instalación. Sin embargo, vale la pena señalar que para las implementaciones de producción siempre es preferible usar rutas absolutas. Consulte [plugin.path](https://kafka.apache.org/quickstart#connectconfigs_plugin.path) para obtener una descripción detallada de cómo establecer esta configuración.

Edite el archivo **config/connect-standalone.properties**, agregue o cambie la propiedad plugin.path  de configuración que coincida con lo siguiente y guarde el archivo: 
```
plugin.path=libs/connect-file-3.2.0.jar
```
Luego, comience creando algunos datos iniciales para probar con: 
```
echo -e "foo\nbar" > prueba.txt
```
A continuación, comenzaremos a ejecutar dos conectores en modo independiente , lo que significa que se ejecutan en un único proceso local dedicado. Proporcionamos tres archivos de configuración como parámetros. El primero es siempre la configuración para el proceso de Kafka Connect, que contiene una configuración común, como los agentes de Kafka a los que conectarse y el formato de serialización de los datos. Cada uno de los archivos de configuración restantes especifica un conector para crear. Estos archivos incluyen un nombre de conector único, la clase de conector para instanciar y cualquier otra configuración requerida por el conector. 

```
 bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
 ```
Estos archivos de configuración de muestra, incluidos con Kafka, usan la configuración de clúster local predeterminada que inició anteriormente y crean dos conectores: el primero es un conector de origen que lee líneas de un archivo de entrada y produce cada una en un topic(tema) de Kafka y el segundo es un conector receptor que lee mensajes de un topic(tema) de Kafka y produce cada uno como una línea en un archivo de salida.

Durante el inicio, verá una serie de mensajes de registro, incluidos algunos que indican que se están creando instancias de los conectores. Una vez que se ha iniciado el proceso de Kafka Connect, el conector de origen debe comenzar a leer líneas **test.txt** y producirlas en el topic(tema) **connect-test**, y ​​el conector receptor debe comenzar a leer mensajes del topic(tema) **connect-test** y escribirlos en el archivo **test.sink.txt**. Podemos verificar que los datos se han entregado a través de toda la canalización examinando el contenido del archivo de salida:
```
more test.sink.txt
foo
bar
```
Tenga en cuenta que los datos se almacenan en el tema de Kafka connect-test, por lo que también podemos ejecutar un consumidor de consola para ver los datos en el tema (o usar un código de consumidor personalizado para procesarlo): 

```bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning
{"schema":{"type":"string","optional":false},"payload":"foo"}
{"schema":{"type":"string","optional":false},"payload":"bar"}
...
```
Los conectores continúan procesando datos, por lo que podemos agregar datos al archivo y verlos moverse a través de la canalización:
```
echo "Another line">> test.txt
```
Debería ver la línea aparecer en la salida del consumidor de la consola y en el archivo receptor.

#### Paso 7: Procese sus eventos con Kafka Streams

Una vez que sus datos se almacenan en Kafka como eventos, puede procesarlos con la biblioteca cliente de [Kafka Streams](https://kafka.apache.org/documentation/streams) para Java/Scala. Le permite implementar aplicaciones y microservicios de misión crítica en tiempo real, donde los datos de entrada y/o salida se almacenan en temas de Kafka. Kafka Streams combina la simplicidad de escribir e implementar aplicaciones estándar de Java y Scala en el lado del cliente con los beneficios de la tecnología de clúster del lado del servidor de Kafka para hacer que estas aplicaciones sean altamente escalables, elásticas, tolerantes a fallas y distribuidas. La biblioteca admite procesamiento exactamente una vez, operaciones con estado y agregaciones, creación de ventanas, uniones, procesamiento basado en tiempo de evento y mucho más.

Para darle una primera muestra, así es como se implementaría el popular algoritmo WordCount:
```
KStream<String, String> textLines = builder.stream("quickstart-events");

KTable<String, Long> wordCounts = textLines
            .flatMapValues(line -> Arrays.asList(line.toLowerCase().split(" ")))
            .groupBy((keyIgnored, word) -> word)
            .count();

wordCounts.toStream().to("output-topic", Produced.with(Serdes.String(), Serdes.Long()));
```
La demostración de [Kafka Streams](https://kafka.apache.org/documentation/streams/quickstart) y el tutorial de [desarrollo de aplicaciones](https://kafka.apache.org/documentation/streams/tutorial) muestran cómo codificar y ejecutar una aplicación de transmisión de este tipo de principio a fin.

#### Paso 8: terminar el entorno de Kafka

Ahora que llegó al final del inicio rápido, no dude en cerrar el entorno de Kafka o seguir jugando.

  1.  Detenga a los clientes productores y consumidores con Ctrl-C, si aún no lo ha hecho.
  2.  Detenga el broker de Kafka con Ctrl-C.
  3.  Por último, detenga el servidor de ZooKeeper con Ctrl-C.

Si también desea eliminar cualquier dato de su entorno local Kafka, incluidos los eventos que haya creado en el camino, ejecute el comando: 

```
rm -rf /tmp/kafka-logs /tmp/zookeeper
```
#### ¡Felicidades!

Ha finalizado con éxito el inicio rápido de Apache Kafka.

Para obtener más información, sugerimos los siguientes pasos:

- Lea la breve [Introducción](https://kafka.apache.org/intro) para aprender cómo funciona Kafka a un alto nivel, sus conceptos principales y cómo se compara con otras tecnologías. Para comprender Kafka con más detalle, diríjase a la [Documentación](https://kafka.apache.org/documentation/).
- Explore los [casos de uso](https://kafka.apache.org/powered-by) para saber cómo otros usuarios de nuestra comunidad mundial obtienen valor de Kafka.
- Únase a un [grupo de reunión local de Kafka](https://kafka.apache.org/events) y vea las [charlas de Kafka Summit](https://kafka-summit.org/past-events/) , la principal conferencia de la comunidad de Kafka.


## 4. Para hacer

### utilizar kafka y postgress

