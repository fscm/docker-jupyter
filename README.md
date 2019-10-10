# Jupyter for Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/fscm/jupyter.svg?color=black&logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/fscm/jupyter)
[![Docker Stars](https://img.shields.io/docker/stars/fscm/jupyter.svg?color=black&logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/fscm/jupyter)
[![Docker Build Status](https://img.shields.io/docker/cloud/build/fscm/jupyter.svg?color=black&logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/fscm/jupyter)

A small Jupyter image that can be used for either Jupyter Notebook or
JupyterLab.

## Supported tags

- `4.6.0`, `latest`

## What is Jupyter Notebook?

> The Jupyter Notebook is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and narrative text.

*from* [jupyter.org](https://jupyter.org)

## What is JupyterLab?

> JupyterLab is a web-based interactive development environment for Jupyter notebooks, code, and data.

*from* [jupyter.org](https://jupyter.org)

## Getting Started

There are a couple of things needed for the script to work.

### Prerequisites

Docker, either the Community Edition (CE) or Enterprise Edition (EE), needs to
be installed on your local computer.

#### Docker

Docker installation instructions can be found
[here](https://docs.docker.com/install/).

### Usage

In order to end up with a functional Jupyter application - after having build
the container - some configurations have to be performed.

To help perform those configurations a small set of commands is included on the
Docker container.

- `help` - Usage help.
- `init` - Configure the Jupyter application (__Not required in this image__).
- `start` - Start the Jupyter service.

To store the documents created in the Jupyter application a volume can be
created and added to the container when running the same.

**Note:** A local folder can also be used instead of a volume. Use the path of
the folder in place of the volume name.

#### Creating Volumes

Creating volumes can be done using the `docker` tool. To create a volume use
the following command:

```
docker volume create --name VOLUME_NAME
```

Two create the required volume the following command can be used:

```
docker volume create --name my_jupyter
```

#### Configuring the Jupyter Application

This step is not required for this Jupyter Docker image.

#### Start the Jupyter Application

After configuring the Jupyter application the same can now be started.

Starting the Jupyter application can be done with the `start` command.

```
docker run --volume JUPYTER_VOL:/work:rw --detach --interactive --tty -p 8888:8888 fscm/jupyter:latest [options] start
```

* `-l` - Starts the JypiterLab environment.
* `-n` - Start the Jupyter Notebook environment (default).

An example on how the Jupyter application can be started:

```
docker run --volume ~/my/jupyter/documents:/work:rw --detach --interactive --tty -p 8888:8888 --name my_jupyter fscm/jupyter:latest start
```

To see the output of the container that was started use the following command:

```
docker attach CONTAINER_ID
```

Use the `ctrl+p` `ctrl+q` command sequence to detach from the container.

#### Open the Jupyter Application

After starting the Jupyter container, open a new browser tab and type in the
following address:

```
http://localhost:8888
```

The Jupyter application, either the Jupyter Notebook or the JupyterLab
depending on which one was started, should now be visible on your browser tab.

#### Install Python Modules

To install Python modules inside the Docker container, open a terminal from
within the Jupyter application. This will provide a fully functional terminal
shell from which the `pip install` command can be run.

#### Stop the Jupyter Application

If needed the Jupyter application can be stoped and later started again (as
long as the command used to perform the initial start was as indicated before).

To stop the application use the following command:

```
docker stop CONTAINER_ID
```

To start the application again use the following command:

```
docker start CONTAINER_ID
```

### Jupyter Application Status

The Jupyter application status can be check by looking at the Jupyter
application output data using the docker command:

```
docker container logs CONTAINER_ID
```

## Build

Build instructions can be found
[here](https://github.com/fscm/docker-jupyter/blob/master/README.build.md).

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/docker-jupyter/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/docker-jupyter/contributors)
who participated in this project.