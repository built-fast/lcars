DIRS=bin share libexec vendor completions
INSTALL_DIRS=`find $(DIRS) -type d`
INSTALL_FILES=`find $(DIRS) -type f -o -type l`

PREFIX?=/usr/local

VERSION?=$(error Must specify version, eg: VERSION=v0.0.0)

.PHONY: help
help: ## show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: test
test: test-shellcheck test-man ## run full test suite

.PHONY: test-shellcheck
test-shellcheck: ## run shellcheck
	./bin/lcars test:shellcheck

.PHONY: test-shfmt
test-shfmt: ## run shfmt
	./bin/lcars test:shfmt contrib libexec share

.PHONY: test-man
test-man: ## check if man page is up to date
	@$(MAKE) man > /dev/null 2>&1
	@if ! git diff --quiet --exit-code share/man/man1/lcars.1; then \
		echo "Error: man page is out of date. Run 'make man' to update it." >&2; \
		exit 1; \
	fi

.PHONY: man
man: share/man/man1/lcars.1 ## build man page

share/man/man1/lcars.1: doc/man/lcars.1.md
	@mkdir -p share/man/man1
	pandoc $< -s -t man -o $@

.PHONY: install
install: ## install LCARS
	for dir in $(INSTALL_DIRS); do mkdir -p $(DESTDIR)$(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp -P $$file $(DESTDIR)$(PREFIX)/$$file; done

.PHONY: uninstall
uninstall: ## uninstall LCARS
	for file in $(INSTALL_FILES); do rm -f $(DESTDIR)$(PREFIX)/$$file; done

.PHONY: archive
archive: ## create a zip archive of the current version
	mkdir -p pkg
	git archive --prefix=lcars-$(VERSION)/ --output=pkg/lcars-$(VERSION).zip $(VERSION) $(INSTALL_FILES)

.PHONY: release
release: ## create a new tag and push to GitHub
	git tag -m "$(VERSION)" $(VERSION)
	git push --tags

.PHONY: format
format: ## format all shell scripts
	shfmt -w -i 2 -sr -ci libexec share contrib
