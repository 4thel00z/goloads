#! /usr/bin/env bash

go mod init app
go mod tidy
go install mvdan.cc/garble@latest



for f in /go/src/app/*.go
do
	echo '[*] Compiling '"$f"' to '"/go/src/app/${f##*/}.exe"
	/app/bin/garble build -o "/go/src/app/${f##*/}.exe" $f
done
