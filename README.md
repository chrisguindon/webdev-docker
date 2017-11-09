# webdev-docker

These images are maintained by the Eclipse Foundation webdev team. They are designed to be used in development only.

## php
You can test your Eclipse project website with *4* php versions.

### Supported tags and respective `Dockerfile` links

* [php5.3](https://github.com/chrisguindon/webdev-docker/blob/master/php/php5.3/Dockerfile)
* [php5.5](https://github.com/chrisguindon/webdev-docker/blob/master/php/php5.5/Dockerfile)
* [php5.6](https://github.com/chrisguindon/webdev-docker/blob/master/php/php5.6/Dockerfile)
* [php7.0](https://github.com/chrisguindon/webdev-docker/blob/master/php/php7.0/Dockerfile)

These images can be pulled from `chrisguindon/webdev:<VERSION>`

```console
docker pull chrisguindon/webdev:php5.6
```

### Example

```console
mkdir eclipse.local && cd eclipse.local
git clone https://git.eclipse.org/r/www.eclipse.org/eclipse.org-common
git clone https://git.eclipse.org/r/www.eclipse.org/users
git clone https://git.eclipse.org/r/www.eclipse.org/downloads
docker run -p 80:80 --name eclipse-webdev-php56 -v "$PWD":/var/www/html -d  chrisguindon/webdev:php5.6
```

The php images are inspired by the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for [php](https://registry.hub.docker.com/_/php/).

## planeteclipse

This image can be pulled from [chrisguindon/webdev:planeteclipse](https://hub.docker.com/r/chrisguindon/webdev).

```console
$ docker pull chrisguindon/webdev:planeteclipse
```

This is a Docker image for planeteclipse.org, created and maintained by Christopher Guindon. The goal of this image is to try to reduce the setup time while working on fixes for the theme. I think this could also be used to generate the static output of Planet Eclipse.

### What is Planet Eclipse?
Planet Eclipse is a window into the world, work and lives of Eclipse hackers and contributors.

For more information, please visit http://planeteclipse.org/planet/.

### Start a planeteclipse-docker instance

Start a planeteclipse-docker instance as follows:

```console
$ docker run --name my-container-name -d \
  -v my-local-planeteclipse-repo:/gitroot/planeteclipse.org \
  -e PLANETECLIPSE_UPDATE=true  \
  -e PLANETECLIPSE_HTTP_SERVER=true  \
  -p 80 \
  chrisguindon/webdev:planeteclipse
```

... where `my-container-name` is the name you want to assign to your container and `my-local-planeteclipse-repo` is your optional local copy of [planeteclipse.org.git](https://git.eclipse.org/c/planeteclipse.org/planeteclipse.org.git).

On docker run, browse to port 80 to view output via python SimpleHTTPServer. The HTTP server will start after building the site. Please be patient, this will take a few minutes.

### Environment Variables

When you start the image, you can adjust some settings with `PLANETECLIPSE_UPDATE` and `PLANETECLIPSE_HTTP_SERVER`.

#### `PLANETECLIPSE_UPDATE`

When this variable is set to `true`, it will update the cache before rebuilding each file. This option requires patience since it will take several minutes to complete.

#### `PLANETECLIPSE_HTTP_SERVER`

When this variable is set to `true`, a http server will serve content from the output folder on port 8080 with python SimpleHTTPServer. This option is useful to keep the container running after updating the cache. 

Please note that Planet creates static content, an http server is not required to view the HTML content. If you decide to enable it, the output folder is hosted in the http://localhost:8080/planet sub-folder.