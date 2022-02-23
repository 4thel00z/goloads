package main

import (
	"fmt"
	"github.com/4thel00z/goloads/pkg/v1/goloads"
	"io/ioutil"
	"os"
	"path/filepath"
)

const (
	EX_STUPID = 1
	EX_USAGE  = 64
)

func usage() {
	fmt.Fprintf(os.Stderr, `usage: %s <path-to-payload-json> <path-to-output>`, os.Args[0])
}

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(EX_USAGE)
	}
	path := os.Args[1]
	outputPath := os.Args[2]

	payload, err := goloads.Load(path)

	if err != nil {
		fmt.Fprintf(os.Stderr, "could not load payload from %s: %s", path, err)
		os.Exit(EX_STUPID)
	}

	compiledPayload, err := payload.Venom()

	if err != nil {
		fmt.Fprintf(os.Stderr, "could not compile payload via %s: %s", path, err)
		os.Exit(EX_STUPID)
	}

	t, err := ioutil.TempFile("goloads", "*")
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not create tempfile %s: %s", path, err)
		os.Exit(EX_STUPID)
	}
	defer t.Close()

	_, err = t.Write([]byte(compiledPayload))

	if err != nil {
		fmt.Fprintf(os.Stderr, "could not write to tempfile %s: %s", path, err)
		os.Exit(EX_STUPID)
	}

	codeFile, err := goloads.GetGoCode("goloads", "*", t.Name())
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not get code file for %s: %s", t.Name(), err)
		os.Exit(EX_STUPID)
	}
	defer codeFile.Close()
	goloads.Garble(filepath.Dir(codeFile.Name()), outputPath, os.Args[3:]...)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not compile the code to %s: %s", outputPath, err)
		os.Exit(EX_STUPID)
	}

}
