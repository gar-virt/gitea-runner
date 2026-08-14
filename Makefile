UPSTREAM_VERSION := v3.1.0
UPSTREAM_DIR := upstream
UPSTREAM_SOURCE_DIR := $(UPSTREAM_DIR)/source
UPSTREAM_SOURCE_URL := https://gitea.com/gitea/runner/archive/$(UPSTREAM_VERSION).tar.gz
UPSTREAM_SOURCE_STAMP := $(UPSTREAM_DIR)/source.stamp
UPSTREAM_BUILD_STAMP := $(UPSTREAM_DIR)/build.stamp

VERSION := $(UPSTREAM_VERSION)-sl.1

.PHONY: build
build: $(UPSTREAM_BUILD_STAMP)

.PHONY: clean
clean:
	rm -rf "$(UPSTREAM_DIR)"

$(UPSTREAM_BUILD_STAMP): $(UPSTREAM_SOURCE_STAMP)
	rm -rf "$(UPSTREAM_SOURCE_DIR)/dist"
	$(MAKE) -C "$(UPSTREAM_SOURCE_DIR)" VERSION=$(VERSION) release
	for f in $$(find "$(UPSTREAM_SOURCE_DIR)/dist/release" -type f -regextype egrep -not -regex '.*\.xz(\.sha256)?'| sort); do \
		rm -f "$${f}"; \
	done
	touch "$@"

$(UPSTREAM_DIR)/source.tar.gz:
	mkdir -p "$(UPSTREAM_DIR)"
	echo '*' > "$(UPSTREAM_DIR)/.gitignore"
	curl -sSLfo "$@" "$(UPSTREAM_SOURCE_URL)"

$(UPSTREAM_SOURCE_STAMP): $(UPSTREAM_DIR)/source.tar.gz
	mkdir -p "$(UPSTREAM_SOURCE_DIR)"
	tar -xf "$(UPSTREAM_DIR)/source.tar.gz" -C "$(UPSTREAM_SOURCE_DIR)" --strip-components 1
	for f in $$(find "$$(pwd)/patches" -type f -name '*.patch' | sort); do \
		patch -p1 -d "$(UPSTREAM_SOURCE_DIR)" -i "$${f}"; \
	done
	touch "$@"
