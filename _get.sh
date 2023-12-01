#!/bin/sh
# $1 = property name
awk -v "prop=$1" -F = '$1==prop{print$2;exit}' "$TAG_HOME/config"
