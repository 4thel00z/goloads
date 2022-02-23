#! /usr/bin/env python3
import sys
import glob
import os
import sys


def read(p):
    with open(p) as f:
        return f.read()


def load_and_replace(in_file, replacements):
    content = read(in_file)

    for before, after in replacements.items():
        content = content.replace(before, after)

    return content


if __name__ == "__main__":
    template_path = sys.argv[1]
    for target in glob.glob(os.environ.get("TARGETS")):
        print("[*] Writing go template for", target, file=sys.stderr)
        new_target = target + ".go"
        target_filename = os.path.basename(target)
        with open(new_target, mode="w") as f:
            print("[*] Writing out go template to: ", new_target)
            f.write(load_and_replace(template_path, {"$PLACEHOLDER$": target_filename}))
