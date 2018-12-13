IMPORT_PATH := github.com/hackerzhut/go-jenkins

# V := 1 # When V is set, print commands and build progress.

# Space separated patterns of packages to skip in list, test, format.
IGNORED_PACKAGES := /vendor/

.PHONY: all
all: build

.PHONY: build
build:
	$Q CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a --installsuffix dist -o main $(if $V,-v) $(VERSION_FLAGS) $(IMPORT_PATH)

.PHONY: test
test: ## Runs the go tests
	@APP_ENV=Test GO111MODULE=on go test -v -tags "$(BUILDTAGS) cgo" $(shell go list ./... | grep -v vendor)
	# @docker rm -f $(shell docker ps -aq)

.PHONY: image
image: ## Creates the docker images of the app and cleanups the intermediate
	@echo '>> building docker image'
	@docker build -t telematicsct/gatekeeper:$(shell cat VERSION) .
	@docker image prune --force --filter label=stage=intermediate