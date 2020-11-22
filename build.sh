#!/usr/bin/env bash

#
# build redis script
#


chmod 744 -R deps
cd ./deps/jemalloc  &&  bash autogen.sh

cd ../ && make hiredis jemalloc linenoise lua

cd ../

make clean

make



