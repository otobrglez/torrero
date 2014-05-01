#!/usr/bin/env bash

ab -n 1000 -c 100 -g kickstarter-1000-100.data \
  https://www.kickstarter.com/discover?ref=nav]

ab -X torrero-main:3113 -n 1000 -c 100 -g kickstarter-torrero-1000-100.data \
  https://www.kickstarter.com/discover?ref=nav
