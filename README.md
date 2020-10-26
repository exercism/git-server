# Exercism's Git Server

![Tests](https://github.com/exercism/git-server/workflows/Tests/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4fa74b662731c5ec239/maintainability)](https://codeclimate.com/github/exercism/git-server/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d4fa74b662731c5ec239/test_coverage)](https://codeclimate.com/github/exercism/git-server/test_coverage)

A server to retrieve data from Exercism's git organisation

## Run locally

This can be run locally using the Procfile or via Docker through the Dockerfile.

To build the Dockerfile, run:

```
docker build -f Dockerfile.dev -t exercism-git-server .
```

To execute the Dockerfile.

```
docker run -p 3022:3022 -v /PATH/TO/PWD:/usr/src/app exercism-git-server:latest
```

For example:

```
docker run -p 3022:3022 -v /Users/iHiD/Code/exercism/git-server:/usr/src/app exercism-git-server:latest
```

It will then sit and wait for messages from the website.
