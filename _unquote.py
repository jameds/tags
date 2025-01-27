#!/usr/bin/env python3

from urllib.parse import unquote
import sys

for line in sys.stdin:
    print(unquote(line[:-1]))
