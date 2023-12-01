#!/bin/sh
cwd="$PWD"
flag=
untagged=
for i; do
	case "$i" in
		/)
			>&2 cat <<-EOT
			/a    Search entire database. (Default searches
			      under this directory only.)
			/u    Find untagged files.
			/v    Print full tags list along with each file.
			EOT
			exit 1
			;;
		/a)
			cwd="$(_get.sh root)"
			;;
		/u)
			untagged=1
			;;
		/v)
			flag+=v
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
		-v "vroot=$(echo "$cwd/" | _file.sh)" \
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
if [ $untagged ]; then
	find "$cwd" -mindepth 1 -maxdepth 1 |
		grep -vFx -f <(grop)
else
	grop
fi
