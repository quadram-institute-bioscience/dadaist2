#!/usr/bin/env python

import os, sys
import argparse

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def loadFile(file):
    """
    Load file lines to a list
    """
    with open(file, 'r') as f:
        lines = f.readlines()
        #Strip new lines
        lines = [line.strip() for line in lines]
    return lines

def stripBuild(lines):
    """
    Strip build from lines
    """
    for i, line in enumerate(lines):
        if '=' in line:
            if len(line.split('=')) > 2:
                lines[i] = '='.join(line.split('=')[0:2])
    
    return lines

def renameEnv(lines, newname):
    """
    Rename environment
    """
    for i, line in enumerate(lines):
        if line.startswith('name: '):
            lines[i] = 'name: ' + newname
    return lines

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Strip conda environment file from build versions")
    parser.add_argument("ENVFILE", help="Conda environment file")
    parser.add_argument("-b", "--keep-build", help="Do not strip build version", action="store_true")
    parser.add_argument("-p", "--keep-prefix", help="Do not strip prefix path", action="store_true")
    parser.add_argument("-n", "--name", help="Rename environment", default=None)
    args = parser.parse_args()

    env = args.ENVFILE
    
    if not os.path.exists(env):
        eprint("File does not exist: {}".format(env))
        sys.exit(1)
    else:
        condaEnv = loadFile(env)
    
    if not args.keep_build:
        condaEnv = stripBuild(condaEnv)
    
    if not args.keep_prefix:
        condaEnv = [line for line in condaEnv if not line.startswith('prefix')]

    if args.name:
        renameEnv(condaEnv, args.name)

    print("\n".join(condaEnv))