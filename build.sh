#!/usr/bin/env bash

#
# build redis script
#

make distclean

cd deps
make hiredis linenoise lua jemalloc
cd ../src
make



