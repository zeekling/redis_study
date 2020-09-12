#!/usr/bin/env bash

#
# build redis script
#

cd ./deps/jemalloc

./autogen.sh

cd ../../

ls -lh ./deps/jemalloc

make clean

make



