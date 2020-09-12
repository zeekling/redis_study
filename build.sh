#!/usr/bin/env bash

#
# build redis script
#

cd ./deps && ./update-jemalloc.sh 5.2.1

cd ./jemalloc &&  ./autogen.sh

cd ../../

make clean

make



