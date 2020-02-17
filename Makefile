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


build-img:
	docker build -t ${DOCKER_REPO}/${PROJ_NAME}:$(RELEASE_TAG) -f docker/Dockerfile .


build-in-docker:
	rm -rf bin/*
	go build -mod=vendor -o bin/${PROJ_NAME}
#	CGO_ENABLED=0 GOOS=linux go build
#	-a -installsuffix cgo -o bin/${PROJ_NAME}


clean:
	rm -rf bin/*
