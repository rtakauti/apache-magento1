#!/usr/bin/env bash

set -e

modgit init
modgit update vindi


exec "$@"
