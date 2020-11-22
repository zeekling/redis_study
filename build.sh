#!/usr/bin/env bash

#
# build redis script
#


cd ./deps/jemalloc &&  ./autogen.sh

cd ../ && make hiredis jemalloc linenoise lua

cd ../

make clean

make



