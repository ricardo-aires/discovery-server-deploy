# Discovery Service

[Discovery Server](https://mvnrepository.com/artifact/com.facebook.airlift.discovery/discovery-server) is part of the Airlift, a framework for building REST services in Java that is used as the foundation for distributed systems like [Presto](https://prestodb.io).

In this repository we will provide some examples of deploying the [Discovery Server](https://repo1.maven.org/maven2/com/facebook/airlift/discovery/discovery-server/1.30/discovery-server-1.30.tar.gz) found in the [Facebook Maven](https://mvnrepository.com/artifact/com.facebook.airlift.discovery/discovery-server) in order to run it sepparetly.

- [Ansible](./ansible/roles/discovery-server/README.MD)
- [Docker](./containers/docker/README.MD)

> In the Presto repo we show Kubernetes integration.

## Architecture

Presto is a distributed system that runs on one or more machines to form a cluster.

An installation will, tipically, include:

- one Presto Coordinator - Machine to which users submit their queries. The Coordinator is responsible for parsing, planning, and scheduling query execution across the Presto Workers. Usually runs the discovery service in embedded mode.
- any number of Presto Workers - Adding more Presto Workers allows for more parallelism and faster query processing.

Presto doesn't have, at this time, HA. For these reason, and because the ultimate goal is to run it in containers we are going to deploy a slightly different architecture, using a dedicated server to run the discover service.

For this we are going to use the latest [Discovery Server](https://repo1.maven.org/maven2/com/facebook/airlift/discovery/discovery-server/1.30/discovery-server-1.30.tar.gz) found in the [Facebook Maven](https://mvnrepository.com/artifact/com.facebook.airlift.discovery/discovery-server).

## Requirements

The Discovery Server is written in Java and requires a Java JVM to be installed on your system.

> At the time: Java 8 Update 161 or higher (8u161+), 64-bit. Both [Oracle JDK](https://www.oracle.com/java/) and [OpenJDK](https://openjdk.java.net/) are supported.

Python 2.4+ is also required and Bash.

## Installing

We will use the latest available [tarball](https://repo1.maven.org/maven2/com/facebook/airlift/discovery/discovery-server/1.30/discovery-server-1.30.tar.gz) from the [Facebook  Maven](https://mvnrepository.com/artifact/com.facebook.airlift.discovery/discovery-server).

Once extracted, it will create a single top-level directory, referred to as the installation directory, that contains:

- `lib/`, contains the the JARs that make up the Discovery Server.
- `bin/`, contains helper launcher scripts to start, stop, restart, kill and get the status of a running Discovery Server.

Consider also:

- `etc/`, the configuration directory, it is created by the user and provide the necessary configurations needed.
- `var/`, data directory, the place where logs are stored and it is created the first time Discovery Server is launched.

> By default the data directory it’s located in the installation directly, but it is recommended to configure it outside, to allow for the data to be preserved across upgrades.

## Configuration

Before running, we need to provide a set of configuration files:

- Discovery Server Configuration
- Discovery Server Node Configuration
- Java Virtual Machine (JVM) Configuration

### Discovery Server Configuration

The configuration for the Discovery Server resides in the `etc/config.properties`. The basic Discovery Server Configuration properties are:

- `http-server.http.port` - setup the port for the HTTP server, for all communication, internal and external.
- `discovery.uri` -  The URI expose the Discovery server. This URI must not end in a slash.

### Discovery Server Node Configuration

The node properties file, `etc/node.properties`, contains configuration specific to the node a minimal example should contain:

- `node.environment` - The name of the environment. All Presto nodes in a cluster must have the same environment name.
- `node.id` - The unique identifier for this node. This must be unique for every node. This identifier should remain consistent across reboots or upgrades of Presto.
- `node.data-dir` - The location of the data directory. By default, will store logs and other data here.

### Java Virtual Machine (JVM) Configuration

The JVM config file, `etc/jvm.config`, contains a list of command line options used for launching the Java Virtual Machine (JVM).

The format of the file is a list of options, one per line. These options are not interpreted by the shell, so options containing spaces or other special characters should not be quoted.

The following provides a good starting point for creating `etc/jvm.config`:

```bash
-server
-mx1G
-XX:+UseConcMarkSweepGC
-XX:+ExplicitGCInvokesConcurrent
-XX:+AggressiveOpts
-XX:+HeapDumpOnOutOfMemoryError
-XX:OnOutOfMemoryError=kill -9 %p
```

Because an `OutOfMemoryError` will typically leave the JVM in an inconsistent state, we write a heap dump (for debugging) and forcibly terminate the process when this occurs.

The `-mx` option is one of the more important properties in this file. It sets the maximum Heap Space for the JVM, how much memory is available for the process.

## Launcher Scripts

The installation directory contains a couple of launcher scripts, mainly the `bin/launcher` which can be used to:

- `bin/launcher run` -  run Discovery Server as a foreground process. Logs and other output are written to stdout and stderr.
- `bin/launcher start` -  run Discovery Server as a background daemon process. Logs and other output are written in `var/log`. This will be located within the installation directly unless you specified a different location in the `etc/node.properties` file.
- `bin/launcher stop` - stop Discovery Server running as a daemon.
- `bin/launcher restart` - stop and start Discovery Server as a daemon.
- `bin/launcher kill` - forcefully stop Discovery Server.
- `bin/launcher status` - obtain the status of Discovery Server.

## Discovery Server LOGS

When running Discovery Server as a background daemon process, logs and other output to Presto are written in `var/log`. This will be located within the installation directly unless you specified a different location in the `etc/node.properties` file.

- `launcher.log` - This log is created by the launcher and is connected to stdout and stderr streams of the server. It will contain a few log messages that occur while the server logging is being initialized and any errors or diagnostics produced by the JVM.
- `server.log` - This is the main log file used by Presto. It will typically contain the relevant information if the server fails during initialization. It is automatically rotated and compressed.
- `http-request.log` - This is the HTTP request log which contains every HTTP request received by the server. It is automatically rotated and compressed.
