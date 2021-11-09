#!/usr/bin/env python3

import os, sys
import subprocess
from string import Template
from select import epoll, EPOLLIN

TEMPLATE="""
cat("Starting\\n")
cat("Starting again\\n")
library(dada2)
cat("Dadaing\\n")
library(notechoppe)
cat("Never\\n")
"""


def read_with_timeout(fd, timeout__s):
    """Reads from fd until there is no new data for at least timeout__s seconds.

    This only works on linux > 2.5.44.
    """
    buf = []
    e = epoll()
    e.register(fd, EPOLLIN)
    while True:
        ret = e.poll(timeout__s)
        if not ret or ret[0][1] is not EPOLLIN:
            break
        buf.append(
            fd.read(1)
        )
    return ''.join(buf)

def runScript(script):
    """
    Given a multiline Rscript (script), feed it to RScript via STDIN
    line by line and return error if one line fails
    """
    p = subprocess.Popen(["Rscript", "--vanilla", "-"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    for line in script.split("\n"):
        stdout_data = p.communicate(input=line.encode())
        print(stdout_data)
      
    return 1
 
if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Run a template')
    parser.add_argument('--template', '-t', type=str, default=TEMPLATE)

    args = parser.parse_args()
    p = subprocess.Popen(["Rscript", "--vanilla", "-"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate(input=args.template.encode())
    print(out.decode())
    print("===")
    print(err.decode())