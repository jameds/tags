#!/bin/sh
awk \
	-v "vfile=$1" \
	'NR%2==0 && $0 == vfile {print NR-1, tags;exit} {tags=$0}' \
	"$TAG_HOME/map"
