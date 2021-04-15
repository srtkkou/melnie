#!/usr/bin/env bash

# 変数初期化漏れ警告
set -u

# バージョンの取得
version=`git log -n 1 --date=short --pretty=format:"%cd-%h"`
echo "* ver: $version"

echo "* go generateの実行"
go generate ./...

echo "* go fmtの実行"
go fmt ./...

echo "* go vetの実行"
go vet ./...

echo "* golintの実行"
golint ./...

echo "* go testの実行"
go test ./...

echo "* メルニエ(ARM6-linux)のビルド: "
env GOARCH=arm GOARM=6 GOOS=linux go build \
  -ldflags "-s -X main.version=$version" \
  -o melnie_arm6.exe cmd/melnie/main.go
if [ $? -eq 0 ]; then
  echo "  OK"
else
  echo "  NG"
fi

echo "* メルニエ(AMD64-linux)のビルド: "
env GOARCH=amd64 GOOS=linux go build \
  -ldflags "-s -X main.version=$version" -race \
  -o melnie_amd64.exe cmd/melnie/main.go
if [ $? -eq 0 ]; then
  echo "  OK"
else
  echo "  NG"
fi
