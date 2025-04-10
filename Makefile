.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


.PHONY: asdf-plugins
asdf-plugins:  ## Install asdf plugins
	#
	# Add plugins from .tool-versions file within the repo.
	@# If the plugin is already installed asdf exits with 2, so grep is used to handle that.
	@for plugin in $$(awk '{print $$1}' .tool-versions); do \
		asdf plugin add $${plugin} 2>&1 | (grep "already added" && exit 0); \
	done
	# Update all plugins to their latest version
	@asdf plugin update --all

.PHONY: asdf-install
asdf-install: asdf-plugins  ## Install tools with asdf
	#
	# Install tools via asdf.
	@asdf install