FROM java:openjdk-8-jre

ENV ELASTICSEARCH_MAJOR 2.2
ENV ELASTICSEARCH_VERSION 2.2.0
ENV ELASTICSEARCH_REPO_BASE http://packages.elasticsearch.org/elasticsearch/2.x/debian

ENV LOGSTASH_MAJOR 2.2
ENV LOGSTASH_VERSION 1:2.2.0-1
ENV LOGSTASH_REPO_BASE http://packages.elasticsearch.org/logstash/${LOGSTASH_MAJOR}/debian

ENV KIBANA_VERSION 4.4.0
ENV KIBANA_SHA1 82fa06e11942e13bba518655c1d34752ca259bab

RUN set -ex && \
    groupadd -r elasticsearch && useradd -r -m -g elasticsearch elasticsearch && \
    groupadd -r logstash && useradd -r -m -g logstash logstash && \
    groupadd -r kibana && useradd -r -m -g kibana kibana && \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    arch="$(dpkg --print-architecture)" && \
	  curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch" && \
	  curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch.asc" && \
	  gpg --verify /usr/local/bin/gosu.asc && \
	  rm /usr/local/bin/gosu.asc && \
	  chmod +x /usr/local/bin/gosu && \
		apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
    echo "deb $ELASTICSEARCH_REPO_BASE stable main" > /etc/apt/sources.list.d/elasticsearch.list && \
    echo "deb $LOGSTASH_REPO_BASE stable main" > /etc/apt/sources.list.d/logstash.list && \
	  apt-get update && \
		apt-get install -y --no-install-recommends elasticsearch=$ELASTICSEARCH_VERSION logstash=$LOGSTASH_VERSION && \
	  for path in \
		  /usr/share/elasticsearch/data \
		  /usr/share/elasticsearch/logs \
		  /usr/share/elasticsearch/config \
		  /usr/share/elasticsearch/config/scripts \
	  ; do \
		  mkdir -p "$path"; \
		  chown -R elasticsearch:elasticsearch "$path"; \
	  done && \
	  mv /opt/logstash /usr/share/ && \
		curl -fSL "https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz" -o kibana.tar.gz && \
	  echo "${KIBANA_SHA1} kibana.tar.gz" | sha1sum -c - && \
	  mkdir -p /usr/share/kibana && \
	  tar -xz --strip-components=1 -C /usr/share/kibana -f kibana.tar.gz && \
	  chown -R kibana:kibana /usr/share/kibana && \
	  rm kibana.tar.gz && \
	  /usr/share/kibana/bin/kibana plugin --install elastic/sense && \
	  chown -R elasticsearch:elasticsearch /usr/share/elasticsearch && \
	  chown -R logstash:logstash /usr/share/logstash && \
	  chown -R kibana:kibana /usr/share/kibana && \
	  mkdir -p /opt/vamp && \
	  apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/share/elasticsearch/bin:/usr/share/logstash/bin:/usr/share/kibana/bin:$PATH

ADD elasticsearch.yml logging.yml /usr/share/elasticsearch/config/
ADD logstash.conf /etc/logstash/conf.d/logstash.conf
ADD kibana.yml /usr/share/kibana/config/kibana.yml
ADD entrypoint.sh kibana.sh logstash.sh /

EXPOSE 9200 9300
EXPOSE 5601
EXPOSE 10001

ENTRYPOINT ["/entrypoint.sh"]
CMD ["elasticsearch"]
