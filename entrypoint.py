#! /usr/bin/env python3

import glob
import os
import sys
import json
import os
import shutil
import subprocess


def flatten(t):
    return [item for sublist in t for item in sublist]


def build(file_name):
    with open(file_name) as f:
        recipe = json.load(f)
        args = {**recipe.get("args"), "-f": "hex"}
        env = recipe.get("env")
        msfvenom = "/usr/src/metasploit-framework/msfvenom"
        cmd = [msfvenom, *flatten(args.items())]
        print("[*] Calling: ", " ".join(cmd), file=sys.stderr)
        return subprocess.Popen(
            cmd,
            env=dict(os.environ, **{str(a): str(b) for a, b in env.items()}),
            stdout=subprocess.PIPE,
        )


targets = os.environ.get("TARGETS")

for target in glob.glob(targets):
    print("[*] building now", target, file=sys.stderr)
    p = build(target)
    out, err = p.communicate()
    if not err:
        with open(target + ".out", mode="wb") as f:
            print("Writing out:", out.decode("ascii", errors="ignore"))
            f.write(out)
