# Jupyter for Docker

Docker image Jupyter Notebook.

## Synopsis

This script will create a Docker image with Jupyter Notebook installed and
with all of the required initialization scripts.

The Docker image resulting from this script should be the one used to
instantiate a Jupyter application.

## Getting Started

There are a couple of things needed for the script to work.

### Prerequisites

Docker, either the Community Edition (CE) or Enterprise Edition (EE), needs to
be installed on your local computer.

#### Docker

Docker installation instructions can be found
[here](https://docs.docker.com/install/).

### Create the Docker Image

In order to create a Docker image using this Dockerfile you need to run the
`docker` command with a few options.

```
docker build --force-rm --no-cache --quiet --tag <USER>/<IMAGE>:<TAG> <PATH>
```

* `<USER>` - *[required]* The user that will own the container image (e.g.: "johndoe").
* `<IMAGE>` - *[required]* The container name (e.g.: "jupyter").
* `<TAG>` - *[required]* The container tag (e.g.: "latest").
* `<PATH>` - *[required]* The location of the Dockerfile folder.

A build example:

```
docker build --force-rm --no-cache --quiet --tag johndoe/my_jupyter:latest .
```

To clean the _<none>_ image(s), left by the build process, the following
command can be used:

```
docker rmi `docker images --filter "dangling=true" --quiet`
```

### Add Tags to the Docker Image

Additional tags can be added to the image using the following command:

```
docker tag <image_id> <user>/<image>:<extra_tag>
```

### Push the image to Docker Hub

After adding an image to Docker, that image can be pushed to a Docker registry... Like Docker Hub.

Make sure that you are logged in to the service.

```
docker login
```

When logged in, an image can be pushed using the following command:

```
docker push <user>/<image>:<tag>
```

Extra tags can also be pushed.

```
docker push <user>/<image>:<extra_tag>
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for more details on how
to contribute to this project.

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/docker-jupyter/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/docker-jupyter/contributors)
who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
file for details