FROM alpine:latest
MAINTAINER Carlos Parodi (cparodif)
RUN mkdir -p /kafka  \
    && apk update &&  apk upgrade  \
    && apk add --update --no-cache  bash curl zip \
    && apk add --update --no-cache openjdk11 \
    && apk add -U tzdata \
    && cp /usr/share/zoneinfo/Europe/Madrid /etc/localtime \
    && echo "Europe/Madrid" > /etc/timezone \
    && apk del tzdata \
    && curl -SL https://downloads.apache.org/kafka/3.2.0/kafka_2.12-3.2.0.tgz -o /kafka.tgz \
    && cd /kafka \
    && tar -xvzf /kafka.tgz --strip 1 \
    && rm /kafka.tgz \  
    && apk add --update --no-cache  nano mc  tmux htop\
    && rm -rf /var/cache/apk/*  /tmp/*   \
    && mkdir -p /tmp/zookeeper \
    && mkdir -p /tmp/kafka-logs 
WORKDIR /kafka
EXPOSE 9092 2181 8083
COPY --chown=root:root  entrypoint.sh /
RUN   chmod +x /entrypoint.sh 
ENTRYPOINT ["/entrypoint.sh"]
