#!/usr/bin/env python3

import glob
import json
import os.path
import sys


def main():
    for dirname in glob.glob("./ports/*/*"):

        pkgname = dirname.split("/")[-1]

        formula = f"./homebrew/formulae/{pkgname}.json"
        if not os.path.exists(formula):
            continue

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
