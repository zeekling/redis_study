#!/usr/bin/env bash

#
# build redis script
#


cd ./deps/jemalloc && ./configure &&  bash autogen.sh

cd ../ && make hiredis jemalloc linenoise lua

cd ../

make clean

make



