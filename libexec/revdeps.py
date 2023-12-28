#!/usr/bin/env python3

"""Obtains the reverse dependencies of each package."""

import glob
import json
import subprocess
import sys
from typing import Dict, List, Set


def main():
    revdeps_set: Dict[str, Set[str]] = {}

    for dirname in glob.glob("./ports/*/*/*"):
        argv = ["./bin/pkg_deps", dirname]
        sys.stderr.write(f"🐚 {' '.join(argv)}\n")
        proc = subprocess.run(
            argv,
            check=True,
            capture_output=True,
            text=True,
            shell=False,
        )
        output = proc.stdout

        tokens = output.split(":")
        if len(tokens) != 2:
            continue
        deps = tokens[1].split()

        for dep in deps:
            revdeps_set.setdefault(dep, set())
            revdeps_set[dep].add(dirname)

    revdeps_full_set: Dict[str, Set[str]] = {}
    for key, values in revdeps_set.items():
        revdeps_full_set.setdefault(key, set())
        full_values: Set[str] = set()
        full_values |= values
        for value in values:
            if value in revdeps_set:
                full_values |= revdeps_set[value]
        revdeps_full_set[key] = full_values

    revdeps_full_list: Dict[str, List[str]] = {}
    for key, values in revdeps_full_set.items():
        revdeps_full_list[key] = list(values)

    json.dump(revdeps_full_list, sys.stdout, indent=4)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
