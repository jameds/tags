#!/bin/sh
set -e
trap '>&2 echo An error occurred, no files have been changed.' ERR

if [ $# -eq 0 ]; then
	_tags.sh | sort | uniq -c | _unquote.py
	exit
fi

lf='
'
ro=1
list=
n=0
for v; do
	n=$((n + 1))

	file="${v%:}"
	if [ ${file:+x} ]; then
		list+="$file$lf"
	fi

	if [ "${v##*:}" = '' ]; then
		ro=
		break
	fi
done

if [ $ro ]; then
	_ins.sh "$@"
else
	shift $n
	echo "${list%$lf}" | xargs -d '\n' _mod.sh "$*"
fi
