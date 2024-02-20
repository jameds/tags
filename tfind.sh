#!/bin/sh
root="$PWD"
flag=
prompt=
untagged=
ab=
match_flag() { echo "$flag" | grep -q "$1"; }
for i; do
	case "$i" in
		/)
			>&2 cat <<-EOT
			/a    Search entire database. (Default searches
			      under this directory only.)
			/i    Print an internal ID instead of a path.
			/p    Prompt for each directory or all regular
			      files grouped together.
			/u    Find untagged files.
			/v    Print full tags list along with each file.

			/N    Print the first N results.
			/+N   Print the last N results.
			/N+M  Print N results, starting after the first
			      M results.
			EOT
			exit 1
			;;
		/[0-9]* | /+[0-9]*)
			ab="${i#/}+"
			;;
		/*)
			for p in $(echo "${i#/}" | fold -w 1); do
				case "$p" in
					a)
						root=""
						;;
					i)
						flag+=i
						;;
					p)
						prompt=1
						;;
					u)
						untagged=1
						;;
					v)
						flag+=v
						;;
				esac
			done
			;;
		*)
			args+="$i "
			;;
	esac
done
args="${args% }"
tf() {
	awk \
		-v "vflag=$flag" \
		-v "vprefix=$(_get.sh root)/" \
		-v "vroot=${root:+$(_file.sh "$root")}" \
		-f "$TAG_LIB/_asoc.awk" \
		-f "$TAG_LIB/_tfind_flag.awk" \
		"$@" \
		-f "$TAG_LIB/_tfind.awk" \
		"$TAG_HOME/map"
}
grop() {
	{ read -r add && read -r sub; } < <(_pat.sh "$args")
	if [ "$args" = - ]; then
		tf -f "$TAG_LIB/_tfind_empty.awk"
	else
		tf \
			-v "vadd=$add" \
			-v "vsub=$sub" \
			-f "$TAG_LIB/_tfind_polar.awk"
	fi
}
range() {
	a="${ab%%+*}"
	b="${ab#*+}"
	b="${b%+}"

	if match_flag v; then
		# /v outputs 2 lines per file
		[ ${a:+x} ] && a=$((a*2))
		[ ${b:+x} ] && b=$((b*2))
	fi

	case "${a:+a}${b:+b}" in
		a)
			head -n "$a"
			;;
		b)
			tail -n "$b"
			;;
		ab)
			awk -v "a=$a" -v "b=$b" 'NR>b&&NR<=a+b'
			;;
		*)
			cat
	esac
}
fn() {
	if [ $untagged ]; then
		# needs an absolute path
		find -H "$PWD" -mindepth 1 -maxdepth 1 |
			grep -vFx -f <(grop)
	else
		grop
	fi | range
}
# FIXME: /p should combine with /v
if [ $prompt ] && ! match_flag v ; then
	fn | _tfind_select.sh
else
	fn
fi
