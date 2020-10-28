#############
## Stage 1 ##
#############
FROM ruby:2.6.6 as builder

RUN set -ex; \
    apt-get update; \
    apt-get install -y cmake ruby-dev;

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN echo "gem: --no-document" > ~/.gemrc &&\
    gem install bundler:2.1.4 && \
    bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install

#############
## Stage 2 ##
#############
FROM ruby:2.6.6-slim-buster

RUN set -ex; \
    apt-get update; \
    apt-get install -y git; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
ENV APP_ENV=production
ENV RACK_ENV=production
ENV EXERCISM_ENV=production

RUN echo "gem: --no-document" > ~/.gemrc && \
    gem install bundler:2.1.4
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# copy the source as late as possible to maximize cache
COPY . .

ENTRYPOINT bundle exec rackup -p 3000 --host 0.0.0.0
