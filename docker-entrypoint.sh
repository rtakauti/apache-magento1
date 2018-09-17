#!/usr/bin/env bash

set -e

modgit init
modgit -b homolog add vindi https://github.com/vindi/vindi-magento.git


exec "$@"
