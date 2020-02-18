COMMIT_HASH = $(shell git rev-parse --short HEAD)
COMMIT = $(shell git rev-parse HEAD)
RET = $(shell git describe --contains $(COMMIT_HASH) 1>&2 2> /dev/null; echo $$?)
PWD = $(shell pwd)
USER = $(shell whoami)
buildTime = $(shell date +%Y-%m-%dT%H:%M:%S%z)
PROJ_NAME = k8s-device-plugin
RELEASE_TAG = v1.12
DOCKER_REPO = ogre0403

ifeq ($(RET),0)
    TAG = $(shell git describe --contains $(COMMIT_HASH))
else
	TAG = $(USER)-$(COMMIT_HASH)
endif


run:
	rm -rf bin/${PROJ_NAME}
	go mod vendor
	go build -mod=vendor   -o bin/${PROJ_NAME}
	./bin/${PROJ_NAME}


run-in-docker:
	docker run -ti --rm  ${DOCKER_REPO}/${PROJ_NAME}:$(TAG)


build-nvml-img:
	docker build -t ${DOCKER_REPO}/${PROJ_NAME}:$(RELEASE_TAG)-nvml -f docker/Dockerfile-nvml .


build-cuda-img:
	docker build -t ${DOCKER_REPO}/${PROJ_NAME}:$(RELEASE_TAG)-cuda -f docker/Dockerfile-cuda .

build-in-docker-nvml:
	rm -rf bin/*
	go build -mod=vendor -o bin/${PROJ_NAME}


build-in-docker-cuda:
	rm -rf bin/*
	go build -o bin/${PROJ_NAME} cmd/cuda/*.go

clean:
	rm -rf bin/*
