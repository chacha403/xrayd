FROM alpine:latest

ADD entrypoint.sh /opt/entrypoint.sh

RUN apk add --no-cache --virtual .build-deps ca-certificates curl  &&  chmod +x /opt/entrypoint.sh

EXPOSE 8080/tcp

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
