#############
## Stage 1 ##
#############
FROM ruby:2.6.6 as builder

RUN set -ex; \
    apt-get update; \
    apt-get install -y cmake ruby-dev;

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.1.4 && \
    bundle install --frozen

#############
## Stage 2 ##
#############
FROM ruby:2.6.6-slim-buster

RUN set -ex; \
    apt-get update; \
    apt-get install -y git; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN gem install bundler:2.1.4
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# copy the source as late as possible to maximize cache
COPY . .

ENV CONTAINER_NAME=git-server

ENTRYPOINT EXERCISM_ENV=development ALWAYS_FETCH_ORIGIN=true bundle exec rackup -p 3022 --host 0.0.0.0

