

cd docker-games-server
docker build -f img/dgs-ubuntu-base/experimental/Dockerfile . -t dgs-ubuntu-base:experimental
docker run -it dgs-ubuntu-base:experimental bash
docker run -d -P dgs-ubuntu-base:experimental

docker build -f img/dgs-ubuntu-minimal/experimental/Dockerfile . -t dgs-ubuntu-minimal:experimental

docker build -f img/dgs-conan-exiles/experimental/Dockerfile . -t dgs-conan-exiles:experimental

										--build-arg HTTP_PROXY="${HTTP_PROXY}" --build-arg HTTPS_PROXY="${HTTPS_PROXY}" \
										--build-arg http_proxy="${http_proxy}" --build-arg https_proxy="${https_proxy}" \
										--build-arg NO_PROXY="${NO_PROXY}" --build-arg no_proxy="${no_proxy}"