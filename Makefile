IMPORT_PATH := github.com/hackerzhut/go-jenkins

# V := 1 # When V is set, print commands and build progress.

# Space separated patterns of packages to skip in list, test, format.
IGNORED_PACKAGES := /vendor/

.PHONY: all
all: build

.PHONY: build
build:
	$Q CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a --installsuffix dist -o main $(if $V,-v) $(VERSION_FLAGS) $(IMPORT_PATH)

test:
	$Q GO111MODULE=on go test $(if $V,-v) -i -race $(allpackages) # install -race libs to speed up next run
ifndef CI
	$Q GODEBUG=cgocheck=2 GO111MODULE=on go test -race $(allpackages)
else
	$Q GODEBUG=cgocheck=2 GO111MODULE=on go test -race $(allpackages)
endif