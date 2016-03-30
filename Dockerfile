FROM magneticio/elastic-base:2.2

ADD logstash.conf /etc/logstash/conf.d/logstash.conf
EXPOSE 10001
