#!/bin/sh
args="$(echo "$*" | tr -s ' ' '\n')"
echo "$args" | sed '/^-/d' | paste -sd ' '
echo "$args" | sed -n '/^-/s/-//p' | paste -sd ' '
