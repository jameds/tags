#!/bin/sh
lf=
awk \
	-v "vls=$(_file.sh "$@")" \
	-f "$TAG_LIB/_asoc.awk" \
	-f "$TAG_LIB/_ins.awk" \
	"$TAG_HOME/map" |
while read -r tags && read -r file; do
	echo "$lf# $file"
	echo "$tags" | tr ' ' '\n' | sort
	lf='
'
done
