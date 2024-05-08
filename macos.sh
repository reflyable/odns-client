services=$(networksetup -listallnetworkservices | grep 'Wi-Fi\|Ethernet\|USB')
while read -r service; do
    echo "Setting DNS for $service"
    networksetup -setdnsservers "$service" 127.0.0.1
done <<< "$services"

cd `dirname $0`
./coredns -conf ./corefile --quiet -pidfile ./pid 2>&1 >/dev/null &
echo "Running"
echo "Print Enter to exit"
read enter
while read -r service; do
    echo "Resetting DNS for $service"
    networksetup -setdnsservers "$service" empty
done <<< "$services"
kill -9 $(cat ./pid)
