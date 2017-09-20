# Slab

A solid starting point for haskell APIs

## Goal

Opinionated Yesod stack for APIs serving frontend applications.

## Organization

0. hi my-project --repository gh:tippenein/slab
1. cd my-project
2. make db_user
3. make

## What you get

A running yesod api with seeds, tests, CI (circle.yml), google oauth, a dumb-simple role system, among other things.

## Using this to serve a frontend

There is a `templates` directory with `default-layout-wrapper.hamlet` which you can serve your initial frontend with (probably linking in something from `static/js/bundle.js` ). The `default-layout.hamlet` is just included if you want to separate the wrapper and actual rendered html further. You can read more about those in yesod documentation.
