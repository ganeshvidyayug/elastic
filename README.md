# Vamp Elastic Stack

Example Elastic stack used for minimal Vamp setup.

- [Elasticsearch](https://www.elastic.co/products/elasticsearch) 5.5.2
- [Kibana](https://www.elastic.co/products/kibana) 5.5.2

## Building

```
docker build --tag magneticio/elastic:5.5 .
```

## Running

```
docker run --net=host magneticio/elastic:5.5
```

In case of Docker 1.10.x or greater `seccomp` should be specified, otherwise:

```
docker run --privileged --net=host magneticio/elastic:5.5
# or
docker run --security-opt=seccomp:unconfined --net=host magneticio/elastic:5.5
```
