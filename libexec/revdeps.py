#!/usr/bin/env python3

"""Obtains the reverse dependencies of each package."""

import glob
import json
import subprocess
import sys
from typing import Dict, List, Set


def dumpset(input: Dict[str, Set[str]]):
    """Dumps a dictionary mapping strings to a set of strings."""
    # Implementation note: we cannot JSON dump a Set.
    dumpable = {key: list(value) for key, value in input.items()}
    json.dump(dumpable, sys.stdout, indent=4)
    sys.stdout.write("\n")


class Deps:
    """Contains forward and reverse dependencies."""

    def __init__(self):
        self.forward: Dict[str, Set[str]] = {}
        self.reverse: Dict[str, Set[str]] = {}

    def dump_forward(self):
        dumpset(self.forward)

    def dump_reverse(self):
        dumpset(self.reverse)

    def load(self):
        """Loads forward and reverse deps."""
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

            # output example:
            #
            # ./ports/x/x/x-1.1.1: ./ports/y/y/y-1.1.1 ./ports/z/z/z-1.1.1
            tokens = output.split(":")
            if len(tokens) != 2:
                continue
            deps = tokens[1].split()

            for dep in deps:
                # set reverse deps
                self.reverse.setdefault(dep, set())
                self.reverse[dep].add(dirname)

                # set forward deps
                self.forward.setdefault(dirname, set())
                self.forward[dirname].add(dep)

    def expand_reverse_deps(self):
        """Transforms the reverse field to include transitive reverse deps."""
        revdeps_full_set: Dict[str, Set[str]] = {}

        for key, values in self.reverse.items():
            revdeps_full_set.setdefault(key, set())
            full_values: Set[str] = set()
            full_values |= values

            for value in values:
                if value in self.reverse:
                    full_values |= self.reverse[value]

            revdeps_full_set[key] = full_values

        self.reverse = revdeps_full_set

    def packages_to_recompile(self, initial: str) -> List[str]:
        """Returns the packages to recompile given a package that was modified."""
        result: List[str] = []

        if initial not in self.reverse:
            raise RuntimeError(f"{initial} is not a dependency")
        result.append(initial)

        return result


def main():
    deps = Deps()
    deps.load()
    deps.expand_reverse_deps()
    deps.dump_reverse()
    recompile = deps.packages_to_recompile("./ports/l/libgpg-error/libgpg-error-1.47")
    json.dump(recompile, sys.stdout)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
