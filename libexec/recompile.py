#!/usr/bin/env python3

"""Recompiles packages after we upgraded a package."""

import argparse
import glob
import logging
import pprint
import subprocess
import sys
from typing import Dict, List, Set


class Deps:
    """Contains forward and reverse dependencies."""

    def __init__(self):
        self.forward: Dict[str, Set[str]] = {}
        self.reverse: Dict[str, Set[str]] = {}

    def load(self):
        """Loads forward and reverse deps."""
        for dirname in glob.glob("./ports/*/*/*"):
            argv = ["./bin/pkg_deps", dirname]
            logging.debug(f"+ {' '.join(argv)}\n")
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

    def expand_reverse_deps(self) -> Dict[str, Set[str]]:
        """Transforms the reverse field to include transitive reverse deps."""
        revdeps_full_set: Dict[str, Set[str]] = {}

        for key, values in self.reverse.items():
            revdeps_full_set.setdefault(key, set())
            full_values: Set[str] = set()

            # we depend on the direct reverse dependencies
            full_values |= values

            # we also include transitive reverse dependencies
            for value in values:
                if value in self.reverse:
                    full_values |= self.reverse[value]

            revdeps_full_set[key] = full_values

        return revdeps_full_set

    def packages_to_recompile(self, initial: str) -> List[str]:
        """Returns the packages to recompile given a package that was modified."""
        result: List[str] = []

        # TODO(bassosimone): when we'll have many packages it may be
        # more efficient to combine expanding with narrowing down
        # and perhaps even to avoid getting all the deps but limiting
        # ourselves to just the target package and expand from there

        # build the full set of packages to recompile
        fullreverse = self.expand_reverse_deps()

        logging.debug(f"fullreverse = {pprint.pformat(fullreverse)}")
        logging.debug(f"initial = {initial}")

        # initial may not be in fullreverse if a package
        # is a terminal package without reverse deps
        if initial not in fullreverse:
            return [initial]

        recompile = fullreverse[initial]
        recompile.add(initial)
        logging.debug(f"recompile = {recompile}")

        # compute narrowed down set of dependencies centered on the initial package
        narrowdeps = self.narrow_down_deps_to_set(recompile)
        narrowdeps[initial] = set()
        logging.debug(f"narrowdeps = {narrowdeps}")

        # continue until we're out of packages
        steps = 0
        while recompile:
            logging.debug(f"step {steps}")
            steps += 1

            processed: Set[str] = set()

            # figure out the next package or packages to recompile
            for pkg, deps in narrowdeps.items():
                # if there are still dependencies for the package we are
                # not ready for recompiling this package yet
                if deps:
                    continue

                # conversely, if deps is empty we can now recompile
                logging.debug(f"recompiling {pkg} with deps {deps}")
                result.append(pkg)
                processed.add(pkg)

            # update existing forward dependencies to take tozap
            # packages out of the equation
            for pkg in processed:
                narrowdeps.pop(pkg)
                if pkg in recompile:
                    recompile.remove(pkg)
                for deps in narrowdeps.values():
                    if pkg in deps:
                        deps.remove(pkg)

            logging.debug(f"recompile = {recompile}")
            logging.debug(f"narrowdeps = {narrowdeps}")

        return result

    def narrow_down_deps_to_set(self, packages: Set[str]) -> Dict[str, Set[str]]:
        """
        Returns a subset of forward dependencies including only the
        packages belonging to the given set of packages.
        """
        result: Dict[str, Set[str]] = {}

        for pkg, deps in self.forward.items():
            # we don't care about packages not in the set
            if pkg not in packages:
                continue

            # we only include the packages within the given set
            diffdeps = deps & packages
            result[pkg] = diffdeps

        return result


def exec_command(argv: List[str], dry_run: bool):
    """Executes a given build command."""
    sys.stderr.write(f"🐚 {' '.join(argv)}\n")
    if not dry_run:
        subprocess.run(argv, check=True)


def do_recompile(packages: List[str], dry_run: bool):
    """Function that recompiles the required packages."""
    for pkg in packages:
        exec_command(["./bin/pkg_build", pkg], dry_run=dry_run)
        exec_command(["./bin/pkg_link", pkg], dry_run=dry_run)


def main():
    parser = argparse.ArgumentParser(
        prog="./bin/pkg_upgrade",
        description="Recompiles packages after a package was modified",
    )
    parser.add_argument(
        "-n", "--dry-run", help="Perform a dry run", action="store_true"
    )
    parser.add_argument(
        "-v", "--verbose", help="Enable verbose mode", action="store_true"
    )
    parser.add_argument("target", help="the package to recompile", nargs=1)
    args = parser.parse_args()
    target = args.target[0]

    # configure logging
    logging_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=logging_level, format="%(levelname)s: %(message)s")

    # load direct and reverse dependencies
    deps = Deps()
    deps.load()

    # figure out which are the packages to recompile
    recompile = deps.packages_to_recompile(target)

    # actually recompile packages
    do_recompile(recompile, args.dry_run)


if __name__ == "__main__":
    main()
