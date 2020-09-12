#!/usr/bin/env bash

#
# build redis script
#

cd ./deps/jemalloc

whereis pkg-config

./autogen.sh

cd ../../

ls -lh ./deps/jemalloc

make clean

make



