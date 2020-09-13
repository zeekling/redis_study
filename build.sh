#!/usr/bin/env bash

#
# build redis script
#

#cd ./deps && ./update-jemalloc.sh 5.2.1

cd ./deps/jemalloc &&  ./autogen.sh

cd ../ && make hiredis jemalloc linenoise lua

cd ../

make clean

make


