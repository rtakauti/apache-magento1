#!/usr/bin/env bash

set -e

cd /var/www/html/
modgit update vindi


exec "$@"
