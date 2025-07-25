export EMACS ?= $(shell which emacs)
CASK_DIR := $(shell cask package-directory)

$(CASK_DIR): Cask
	cask eval '(progn (when (version< emacs-version "27") (setq package-check-signature nil)) (cask-cli/install))'
	@touch $(CASK_DIR)

.PHONY: cask
cask: $(CASK_DIR)

clean:
	cask clean-elc

.PHONY: compile
compile: cask clean
	cask build

.PHONY: test
test: cask clean
	cask exec buttercup --traceback full -L . test

.PHONY: coverage
coverage: cask clean
	mkdir -p coverage
	UNDERCOVER_FORCE=true cask exec buttercup --traceback full -L . test
