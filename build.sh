#!/usr/bin/env bash

#
# build redis script
#

#make clean
make && make PREFIX=/usr/local/redis install

if [ ! -d "/usr/local/redis/config/" ]
then
	mkdir -p /usr/local/redis/config/
fi

# copy conf file
if [ ! -d "/usr/local/redis/config/redis.conf" ]
then
	echo "copy redis.conf"
	cp ./redis.conf /usr/local/redis/config/
fi

if [ ! -d "/usr/local/redis/config/sentinel.conf" ]
then
	echo "copy sentinel.conf"
	cp ./sentinel.conf /usr/local/redis/config/
fi

