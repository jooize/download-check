#!/bin/sh

# $1 = URL
# $2 = Checksum

url="$1"
checksum="$2"

url="http://pkg.freebsd.org/FreeBSD:11:armv6/latest/All/pkg-1.6.4_1.txz"
checksum="e607f9704071c171246693652743df2a6117c69f1bd8e41181744421cc595e62"

user1="jooize"
server1="esko.bar"
user2=""
server2=""

# FIXME: Improve regex.
file="$(echo -n $url | sed 's:^.*/\([^/]*\)$:\1:')"

echo Logging in to $server1 as $user1 to download $file ...
ssh $user1@$server1 curl -sO $url

if [ $? -ne 0 ]; then
    echo Download failed with $server1 as $user1.
    exit 1
fi

execute1="shasum -a 256 $file"

checksum1="$(ssh $user1@$server1 $execute1)"

if [ "$checksum1" == "$checksum  $file" ]; then
    echo $server1: OK
else
    echo $server1: DIFFERS
    error=1
fi

exit $error
