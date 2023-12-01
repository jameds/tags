#!/bin/sh
awk 'NR%2' "$TAG_HOME/map" | tr ' ' '\n'
