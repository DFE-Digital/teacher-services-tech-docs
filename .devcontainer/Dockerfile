FROM ruby:3.4.10-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs yamllint \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --version 2.3.16 --no-document \
    && groupadd --gid 1000 developer \
    && useradd --uid 1000 --gid developer --create-home --shell /bin/bash developer \
    && chown -R developer:developer /usr/local/bundle

USER developer
