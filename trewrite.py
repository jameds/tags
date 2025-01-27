#!/usr/bin/env python

from urllib.parse import unquote
import os
import re
import sys

if len(sys.argv) < 2:
    print(f'''\
Usage: {sys.argv[0]} <pattern file> [map file]

Pattern file should have this format per line:

    /<regex>/ replacement
''', file=sys.stderr)
    sys.exit(1)

patterns = []

syntax = re.compile(r'/(.*?)(?!\\)/\s*(.*)')

with open(sys.argv[1]) as f:
    for line in f:
        line = line[:-1]

        if line:
            m = re.search(syntax, line)
            if m:
                patterns.append([
                    re.compile(m.group(1)),
                    m.group(2).replace('\\ ', ' '),
                ])

if len(sys.argv) == 3:
    fn = sys.argv[2]
else:
    fn = os.environ['TAG_HOME'] + '/map'

def conv(t):
    t = unquote(t)
    for pat, repl in patterns:
        t = re.sub(pat, repl, t)
    return t.replace(' ', '%20')

with sys.stdin if fn == '-' else open(fn) as f:
    for nr, line in enumerate(f, 1):
        line = line[:-1]

        if nr % 2:
            print(*map(conv, line.split(' ')))
        else:
            print(line)
