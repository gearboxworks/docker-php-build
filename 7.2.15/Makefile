#
# Standard version level Makefile used to build a Docker container for Gearbox - https://github.com/gearboxworks/gearbox/
#


# Determine whether we use "nodeJS" or "JQ".
JSONCMD := $(shell jq -r '.organization' ./gearbox.json)
ifneq ($(JSONCMD),)
define GetFromPkg
$(shell jq -r ".$(1)" ./gearbox.json)
endef

define rawJSON
$(shell jq -Mc -r '' ./gearbox.json)
endef

else
JSONCMD := $(shell node -p "require('./gearbox.json').organization")
ifneq ($(JSONCMD),)
define GetFromPkg
$(shell node -p "require('./gearbox.json').$(1)")
endef

define rawJSON
$(shell node -p "require('./gearbox.json')")
endef

else
$(shell )

endif
endif

# Set global variables from container file.
ORGANIZATION	:= $(call GetFromPkg,organization)
NAME		:= $(call GetFromPkg,name)
VERSION		:= $(call GetFromPkg,version)
MAJORVERSION	:= $(call GetFromPkg,majorversion)
LATEST		:= $(call GetFromPkg,latest)
CLASS		:= $(call GetFromPkg,class)
NETWORK		:= $(call GetFromPkg,network)
PORTS		:= $(call GetFromPkg,ports)
VOLUMES		:= $(call GetFromPkg,volumes)
RESTART		:= $(call GetFromPkg,restart)
ARGS		:= $(call GetFromPkg,args)
STATE		:= $(call GetFromPkg,state)
ENV		:= $(call GetFromPkg,env)


# The critical bit. Determines what Dockerfile to build against.
ifeq ($(BUILD_TYPE),base)
DOCKERFILE	:= DockerfileBase
BUILD_ARGS	:= --build-arg BUILD_TYPE="$(BUILD_TYPE)"
NAME		:= $(NAME)-$(BUILD_TYPE)

else ifeq ($(BUILD_TYPE),full)
DOCKERFILE	:= DockerfileFull
BUILD_ARGS	:= --squash
NAME		:= $(NAME)

else ifeq ($(BUILD_TYPE),final)
DOCKERFILE	:= DockerfileFinal
BUILD_ARGS	:= 
NAME		:= $(NAME)

else
DOCKERFILE	:= 
BUILD_ARGS	:= 
NAME		:= 
endif


IMAGE_NAME	?= $(ORGANIZATION)/$(NAME)
CONTAINER_NAME	?= $(NAME)-$(VERSION)
CONTAINER_JSON	?= '$(call rawJSON)'


# LOGFILE := $(NAME)-$(shell date +'%Y%m%d-%H%M%S').log
LOGFILE := $(NAME).log


.PHONY: build push release clean list inspect test create shell run start stop rm

################################################################################
# Image related commands.
default: all

all:
	@echo "clean		- Clean base & final container image."
	@echo "build		- Build base & final container image."
	@echo "test		- Execute base & final container unit tests."
	@echo "push		- Push base & final container image to DockerHub & GitHub."
	@echo ""
	@echo "clean-base	- Clean base container image, [DockerfileBase]."
	@echo "build-base	- Build base container image, [DockerfileBase]."
	@echo "test-base	- Execute base container unit tests, [DockerfileBase]."
	@echo "push-base	- Push base container image to DockerHub & GitHub, [DockerfileBase]."
	@echo ""
	@echo "clean-final	- Clean final container image, [DockerfileFinal]."
	@echo "build-final	- Build final container image from base container image, [DockerfileFinal]."
	@echo "test-final	- Execute final container unit tests, [DockerfileFinal]."
	@echo "push-final	- Push final container image to DockerHub & GitHub, [DockerfileFinal]."
	@echo ""
	@echo "build-full	- Generate runtime container image without base reference, [DockerfileFull]."
	@echo ""
	@echo "info-base	- Generate PHP info from base container image."
	@echo "info		- Generate PHP info from final container image."
	@echo ""
	@echo "Process:"
	@echo "	make clean-base"
	@echo "	make build-base"
	@echo "	make clean"
	@echo "	make build"


################################################################################
info: $(DOCKERFILE)
	@make info-real BUILD_TYPE="base"
	@make info-real BUILD_TYPE="final"

clean: $(DOCKERFILE)
	@make clean-real BUILD_TYPE="base"
	@make clean-real BUILD_TYPE="final"
	@make clean-real BUILD_TYPE="full"

build: $(DOCKERFILE)
	@make build-real BUILD_TYPE="base"
	@make build-real BUILD_TYPE="final"

push: $(DOCKERFILE)
	@make push-real BUILD_TYPE="base"
	@make push-real BUILD_TYPE="final"

release: $(DOCKERFILE)
	@make release-real BUILD_TYPE="base"
	@make release-real BUILD_TYPE="final"

list: $(DOCKERFILE)
	@make list-real BUILD_TYPE="base"
	@make list-real BUILD_TYPE="final"

log: $(DOCKERFILE)
	@make log-real BUILD_TYPE="base"
	@make log-real BUILD_TYPE="final"

inspect: $(DOCKERFILE)
	@make inspect-real BUILD_TYPE="base"
	@make inspect-real BUILD_TYPE="final"

test: $(DOCKERFILE)
	@make test-real BUILD_TYPE="base"
	@make test-real BUILD_TYPE="final"

readme:
	@cat README.md


################################################################################
info-%: $(DOCKERFILE)
	@make info-real BUILD_TYPE="$*"

clean-%: $(DOCKERFILE)
	@make clean-real BUILD_TYPE="$*"

build-%: $(DOCKERFILE)
	@make build-real BUILD_TYPE="$*"

push-%: $(DOCKERFILE)
	@make push-real BUILD_TYPE="$*"

release-%: $(DOCKERFILE)
	@make release-real BUILD_TYPE="$*"

list-%: $(DOCKERFILE)
	@make list-real BUILD_TYPE="$*"

log-%: $(DOCKERFILE)
	@make log-real BUILD_TYPE="$*"

inspect-%: $(DOCKERFILE)
	@make inspect-real BUILD_TYPE="$*"

test-%: $(DOCKERFILE)
	@make test-real BUILD_TYPE="$*"


################################################################################
info-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	-docker run --rm -it $(IMAGE_NAME):$(VERSION) php -m > $(NAME)-modules.txt
	-docker run --rm -it $(IMAGE_NAME):$(VERSION) php -i > $(NAME)-info.txt


################################################################################
build-real: $(DOCKERFILE)
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	script -r -t 10 logs/$(LOGFILE) docker build -t $(IMAGE_NAME):$(VERSION) --label gearbox.json='$(call rawJSON)' --label container.organization="$(ORGANIZATION)" --label container.name="$(NAME)" --label container.version="$(VERSION)" --label container.majorversion="$(MAJORVERSION)" --label container.latest="$(LATEST)" --label container.class="$(CLASS)" --label container.network="$(NETWORK)" --label container.ports="$(PORTS)" --label container.volumes="$(VOLUMES)" --label container.restart="$(RESTART)" --label container.args="$(ARGS)" --label container.env="$(ENV)" --build-arg $(ENV)="$(VERSION)" $(BUILD_ARGS) -f $(DOCKERFILE) .
	@echo "Gearbox: Log file saved to \"logs/$(LOGFILE)\""
ifneq ($(MAJORVERSION),)
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):$(MAJORVERSION)
endif
	-docker run --rm -it $(IMAGE_NAME):$(VERSION) php -m > $(NAME)-modules.txt
	-docker run --rm -it $(IMAGE_NAME):$(VERSION) php -i > $(NAME)-info.txt


################################################################################
push-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker push $(IMAGE_NAME):$(VERSION)
ifneq ($(MAJORVERSION),)
	docker push $(IMAGE_NAME):$(MAJORVERSION)
endif


################################################################################
release-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	@make clean
	@make build
	@make push


################################################################################
clean-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	-docker image rm -f $(IMAGE_NAME):$(VERSION)
ifneq ($(MAJORVERSION),)
	-docker image rm -f $(IMAGE_NAME):$(MAJORVERSION)
endif
	-rm -f php-base-info.txt php-base-modules.txt php-info.txt php-modules.txt build/output/$(NAME)-$(VERSION).tar logs/*.log


################################################################################
list-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	-docker image ls $(IMAGE_NAME):$(VERSION)
ifneq ($(MAJORVERSION),)
	-docker image ls $(IMAGE_NAME):$(MAJORVERSION)
endif


################################################################################
inspect-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker image inspect $(IMAGE_NAME):$(VERSION)


################################################################################
log-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	@script -dp logs/$(LOGFILE) | less -SinR


################################################################################
test-real:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	make -k stop; make -k rm
	make -k clean; make -k build; make -k create; make -k start


################################################################################
# Container related commands.

create:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker create   --name $(CONTAINER_NAME) $(RESTART)  $(NETWORK) $(PORTS) $(ARGS) $(VOLUMES) $(IMAGE_NAME):$(VERSION)


################################################################################
shell:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker run --rm --name $(CONTAINER_NAME)-shell -i -t $(NETWORK) $(PORTS) $(ARGS) $(VOLUMES) $(IMAGE_NAME):$(VERSION) /bin/bash -l


################################################################################
run:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker run --rm --name $(CONTAINER_NAME)             $(NETWORK) $(PORTS) $(ARGS) $(VOLUMES) $(IMAGE_NAME):$(VERSION)


################################################################################
start:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker start $(CONTAINER_NAME)


################################################################################
stop:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker stop $(CONTAINER_NAME)


################################################################################
rm:
ifeq ($(STATE),not_supported)
	@echo "Gearbox: Not supported yet."
	@exit 1
endif
ifeq ($(ORGANIZATION),)
	@echo "Gearbox: ERROR - You need to install JQ or NodeJS."
	@exit 1
endif
ifeq ($(DOCKERFILE),)
	@echo "Gearbox: ERROR - Unknown build type."
	@exit 1
endif
	docker container rm -f $(CONTAINER_NAME)


################################################################################

