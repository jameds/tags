#!/bin/sh
set -e
set -o pipefail

{ read -r add && read -r sub; } < <(_pat.sh "$1")
shift
list="$(_file.sh "$@")"

exec 3>&1

_backup.sh &
bk=$!

tmp=
trap 'rm -f "$tmp"' EXIT
tmp="$(mktemp)"

awk \
	-v "vadd=$add" \
	-v "vsub=$sub" \
	-v "vls=$list" \
	-v "vtty=/dev/fd/3" \
	-f "$TAG_LIB/_asoc.awk" \
	-f "$TAG_LIB/_repat.awk" \
	"$TAG_HOME/map" > "$tmp"

wait $bk # wait for backup to finish
mv "$tmp" "$TAG_HOME/map"
