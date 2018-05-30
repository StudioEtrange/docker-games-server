# docker-games-server


### Build


1. build base images

```
VERSION=experimental

cd docker-games-server
docker build -f img/dgs-ubuntu-base/${VERSION}/Dockerfile . -t dgs-ubuntu-base:${VERSION}

docker build -f img/dgs-ubuntu-minimal/${VERSION}/Dockerfile . -t dgs-ubuntu-minimal:${VERSION}

```

1. test base images

```
VERSION=experimental
docker run -it dgs-ubuntu-minimal:${VERSION} bash
docker run -d -P dgs-ubuntu-minimal:${VERSION}
```


1. build game image

```
VERSION=experimental
SERVER=dgs-conan-exiles

cd docker-games-server
docker build -f img/${SERVER}/${VERSION}/Dockerfile . -t ${SERVER}:${VERSION}
```
										--build-arg HTTP_PROXY="${HTTP_PROXY}" --build-arg HTTPS_PROXY="${HTTPS_PROXY}" \
										--build-arg http_proxy="${http_proxy}" --build-arg https_proxy="${https_proxy}" \
										--build-arg NO_PROXY="${NO_PROXY}" --build-arg no_proxy="${no_proxy}"
```
