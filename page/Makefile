.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Jekyll
JEKYLL_CMD = bundle exec jekyll

.PHONY: serve
serve: ## Serve jekyll site with livereload
	@echo "Serving site at http://localhost:4000"
	$(JEKYLL_CMD) serve --livereloa

.PHONY: build
build: ## Build jekyll site
	@echo "Building site at target"
	$(JEKYLL_CMD) build

.PHONY: new_post
new-post: ## Create a new post
	$(JEKYLL_CMD) new post

.PHONY: clean
clean: ## Clean jekyll site
	@echo "Cleaning site"
	$(JEKYLL_CMD) clean
