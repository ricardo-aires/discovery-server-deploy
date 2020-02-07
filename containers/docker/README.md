# Discovery Server Dockerfile

This project provides a way to run a containerised Discovery Server to be used with [Presto](https://prestodb.io).

> The solutions provided were designed for Proof of Concepts. Hence, are not to be treated as production ready, especially because of the lack of Security settings.

## Getting Started

In order to build the image just clone the repo to your machine and run [docker build](https://docs.docker.com/engine/reference/commandline/build/) inside this directory. Example:

```bash
docker build -t discovery-server:1.0 ./build/discovery-server
```

To run a simple test:

```bash
docker container run --rm  discovery-server:1.0
```

### Prerequisities

In order to build the image and run this container you'll need docker installed.

This was tested using [Docker Desktop](https://www.docker.com/products/docker-desktop) for MacOS version 2.1.0.5.

### Base Image

The base image used in this case was the [openjdk:8 Docker Official Image](https://hub.docker.com/_/openjdk). When running inside a organization we should use a base image with:

- java
- python 2.4+
- bash
- wget

### Usage

In order to achieve persistence we must provide a container an `hostname` and a `volume`.

The volume where the Discovery Server stores the Data Directory targets `/data`.

```bash
docker container run -v ds-data,/data -h discovery --name discovery discovery-server:1.0
```

#### Ports

The port `8441` is expose and you may want to publish to test the api:

```bash
docker container run -p 8411:8411 -v ds-data,/data -h discovery --name discovery discovery-server:1.0
```

#### Environment Variables

For the discovery server image there are only two variables:

- `DISCOVERY_HEAP_SIZE`: heap size to allocate to the service, defaults to `1G`.
- `DISCOVERY_ENV`: name of the environment, defaults to `docker`.

## Docker Compose

Due to the simple nature of the Discovery Server no [docker-compose file](https://docs.docker.com/compose/compose-file/) is provided, but we show case the integration in the [Presto repo](https://github.com/ricardo-aires/presto-deploy/tree/master/containers/README.md#Docker-Compose).

## Kubernetes

Again, Discovery Server is a simple process we only need to make sure the port is available and data is retained. We show an integration in the [Presto repo](https://github.com/ricardo-aires/presto-deploy/tree/master/containers/README.md#Kubernetes).
