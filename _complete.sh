#!/bin/sh
case "$1" in
	-*)
		p=-
		;;
	*)
		p=
esac
_tags.sh | sort -u | paste -sd ' ' | awk \
	-v "vtag=${1#-}" \
	-v "vprefix=$p" \
	-f "$TAG_LIB/_complete.awk" | xargs printf '%q\n'
