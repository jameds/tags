#!/bin/sh
list=
d=
while read -r f
do
	[ -d "$f" ] && { p=/; d=1; } || p=
	list+="
$(stat -c "$p	%Y	%n" "$f")"
done

[ ${list:+x} ] || exit

list="$(echo "${list#
}" | sort -t '	' -k 1,1r -k 2,2n)"

if [ $d ]; then
	{
		echo "$list" |
			awk \
			-v "vroot=$(_get.sh root)" \
			-f "$TAG_LIB/_tfind_ls.awk" |
			sort -nr
		echo -n 'Pick an option: '
	} > /dev/tty
	read -r nr < /dev/tty
	echo "$list" | {
		if [ ${nr:+x} ]; then
			awk -v "vn=$nr" -f "$TAG_LIB/_tfind_select.awk"
		else
			awk -f "$TAG_LIB/_tfind_select_default.awk"
		fi
	}
else
	echo "$list" | cut -f 3
fi
