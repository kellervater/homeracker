FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install Ruby and dependencies
RUN apt-get update && \
    apt-get install -y ruby-full build-essential zlib1g-dev nodejs && \
    gem install bundler jekyll

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
