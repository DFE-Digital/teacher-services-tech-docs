FROM ruby:3.4.10-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs yamllint \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --version 2.3.16 --no-document \
    && groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --create-home --shell /bin/bash vscode \
    && chown -R vscode:vscode /usr/local/bundle

USER vscode
