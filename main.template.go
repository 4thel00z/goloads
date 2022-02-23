package main

import (
	_ "embed"

	shellcode "github.com/brimstone/go-shellcode"
)

//go:embed $PLACEHOLDER$
var b []byte

func main() {
	shellcode.Run(b)
}
