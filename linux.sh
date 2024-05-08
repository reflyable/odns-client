#!/bin/bash
echo "nameserver 127.0.0.1" > /etc/resolv.conf
cd `dirname $0`
./coredns -conf ./corefile --quiet -pidfile ./pid 2>&1 >/dev/null &
echo "Running"
echo "Print Enter to exit"
read enter
kill -9 $(cat ./pid)