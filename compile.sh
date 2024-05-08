#!/bin/sh

mkdir win-amd64
cp windows.exe ./win-amd64
mkdir macos-amd64
cp macos.sh ./macos-amd64
mkdir macos-arm64
cp macos.sh ./macos-arm64

mkdir linux-amd64
cp linux.sh ./linux-amd64

git clone https://github.com/coredns/coredns
cd coredns
sed  -i '50 i vpn-send:github.com/reflyable/odns/vpn-send' plugin.cfg
go generate coredns.go
go get



CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o ../macos-arm64
CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o ../macos-amd64
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ../linux-amd64
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o ../win-amd64

cd ..

zip -r ./macos-arm64.zip ./macos-arm64
zip -r ./macos-amd64.zip ./macos-amd64
zip -r ./linux-amd64.zip ./linux-amd64
zip -r ./win-amd64.zip ./win-amd64