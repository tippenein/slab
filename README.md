# Slab

A solid starting point for haskell APIs

## Goal

Opinionated Yesod stack for APIs serving frontend applications.

# Get Started

If you don't have stack, install it
`curl -sSL https://get.haskellstack.org/ | sh`

This uses `hi` to provide the bootstrapping

0. stack install --resolver=lts-7.18 hi
  - if it fails `git clone git@github.com:trofi/hi && cd hi && stack install && cd ..`
1. hi my_project --repository gh:tippenein/slab
2. cd my_project
3. make db_user
4. make

## What you get

A running yesod api with seeds, tests, CI (circle.yml), google oauth, a dumb-simple role system, among other things.

## Database specific

There are a variety of convenience commands in the Makefile:

```
make db       - creates the database if it doesn't exist already
make db_down  - drops the database
make db_test  - creates the test database
make db_user  - creates the postgres user for the db (should only be needed initially)
make db_reset - drop, create, and seed
make seed     - run seeds (config/Seed.hs)
```

## Docker

To build and push a docker container to dockerhub, use `make publish`. From there it's up to you :D

## Using this to serve a frontend

There is a `templates` directory with `default-layout-wrapper.hamlet` which you can serve your initial frontend with (probably linking in something from `static/js/bundle.js` ). The `default-layout.hamlet` is just included if you want to separate the wrapper and actual rendered html further. You can read more about those in yesod documentation.
