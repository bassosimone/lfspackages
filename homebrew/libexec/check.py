#!/usr/bin/env python3

"""
Ensures that packages are in sync with homebrew. You need to
periodically run ./homebrew/libexec/sync to refresh information
about packages managed by homebrew.
"""

import glob
import json
import os.path
import sys


def main():
    for dirname in glob.glob("./ports/*/*"):
        pkgname = dirname.split("/")[-1]

        formula = f"./homebrew/formulae/{pkgname}.json"
        if not os.path.exists(formula):
            sys.stderr.write(f"warning: {formula} does not exist\n")
            continue

        sys.stderr.write(f"info: checking {formula}...\n")
        with open(formula, "r") as filep:
            version = json.load(filep)["versions"]["stable"]

            # note: the directory inside does not include the @ sign
            if "@" in pkgname:
                pkgname = pkgname.split("@")[0]

            package_bash_dir = f"{dirname}/{pkgname}-{version}"
            if not os.path.isdir(package_bash_dir):
                sys.stderr.write(f"warning: {package_bash_dir} does not exist\n")


if __name__ == "__main__":
    main()
