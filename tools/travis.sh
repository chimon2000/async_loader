#!/usr/bin/env bash

# Fast fail the script on failures.
# and print line as they are read
set -ev

flutter --version

flutter packages get

flutter analyze --no-current-package lib

# example
pushd example

flutter packages get

flutter analyze --no-current-package lib
