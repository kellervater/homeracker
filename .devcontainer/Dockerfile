FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install Ruby and dependencies
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install ruby-full build-essential zlib1g-dev -y
RUN echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc && \
    echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
RUN gem install jekyll bundler

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
