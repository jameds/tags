#!/bin/sh
ins() {
	local file="$(realpath "$1" | "$TAG_HOME/_file.sh")"
	echo "$file"
	[ ${file:+x} ] && "$TAG_HOME/_ins.sh" "$file"
}

# NOTE: modifies outside scope variables
info() {
	i="$(ins "$1")"
	file="$(echo "$i" | sed -n '1p')"
	i="$(echo "$i" | sed -n '2p' | tr ' ' '\n')"
	lnum="$(echo "$i" | sed '1q')"
	tags="$(echo "$i" | sed '1d')"
}

merge() {
	echo "$pat" | sed -n '1p' | tr ' ' '\n'
	echo "$tags" | grep -vFx -f "$sub"
}

alter() {
	local i file lnum tags bk sub
	info "$1"

	trap 'rm -f "$sub" "$bk"' EXIT

	sub="$(mktemp)"
	echo "$pat" | sed -n '2p' | tr ' ' '\n' > "$sub"

	line="$(merge | sed '/^$/d' | sort -u | paste -sd ' ')"

	bk="$(mktemp)"

	if [ ${i:+x} ]; then
		awk \
			-v "vline=$line" \
			-v "vlnum=$lnum" \
			-f "$TAG_HOME/_repl.awk" "$TAG_HOME/map" > "$bk"
	else
		cat "$TAG_HOME/map" - > "$bk" <<-EOT
		$line
		$file
		EOT
	fi

	_backup.sh
	mv "$bk" "$TAG_HOME/map"

	rm -f "$bk" "$sub"
}

set -e
trap '>&2 echo An error occurred, no files have been changed.' ERR

if [ $# -eq 0 ]; then
	_tags.sh | sort | uniq -c
elif [ $# -eq 1 ]; then
	info "$1"
	echo "$tags" | sort
else
	mode=
	tags=

	for i; do
		if [ $mode ]; then
			tags+="$i "
		fi
		if [ "${i##*:}" = '' ]; then
			mode=1
		fi
	done

	if [ ! ${tags:+x} ]; then
		exit
	fi

	pat="$(_pat.sh "$tags")"

	for i; do
		file="${i%:*}"

		if [ ${file:+x} ]; then
			alter "$file"
		fi

		if [ "${i##*:}" = '' ]; then
			break
		fi
	done
fi
