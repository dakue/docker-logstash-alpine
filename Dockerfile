FROM fabric8/java-alpine-openjdk8-jre

ENV LOGSTASH_HOME="/opt/logstash" \
  LOGSTASH_VERSION="1.5.4" \
  GOSU_VERSION="1.4" \
  AB_HOME="/opt/agent-bond" \
  AB_VERSION="0.1.0"

RUN set -x && \
  apk --update add bash tar ca-certificates && \
  curl -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" -o /usr/local/bin/gosu && \
  chmod +x /usr/local/bin/gosu && \
  addgroup logstash && \
  adduser -g "Logstash" -s /bin/bash -D -H -G logstash logstash && \
  mkdir -p $LOGSTASH_HOME && \
  curl -sSL "https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz" \
  | tar xz --strip-components=1 -C $LOGSTASH_HOME && \
  apk del curl ca-certificates tar && \
  rm /var/cache/apk/*

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9092 8778 9779

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["logstash", "agent"]
