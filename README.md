# Vamp Elastic Stack

Example Elastic stack used for minimal Vamp setup.
 
## Base image

Defined in `base` directory. Includes:

- [Elasticsearch](https://www.elastic.co/products/elasticsearch) 2.2
- [Logstash](https://www.elastic.co/products/logstash) 2.2
- [Kibana](https://www.elastic.co/products/kibana) 4.4

## Main image

Extends the base image with Logstash configuration for [VGA](https://github.com/magneticio/vamp-gateway-agent).

## Building images 

- build the base image, e.g. `docker build magneticio/elastic-base:2.2 base/.`
- build the main image, e.g. `docker build magneticio/elastic:2.2 .`

## Running 

`docker run --net=host magneticio/elastic:2.2`

In case of Docker 1.10.x or greater `seccomp` should be specified, otherwise:

`docker run --privileged --net=host magneticio/elastic:2.2` or `docker run --security-opt=seccomp:unconfined --net=host magneticio/elastic:2.2`
