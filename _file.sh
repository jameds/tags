#!/bin/sh
set -e
set -o pipefail
root="$(_get.sh root)"
for file; do
	p="${file##/*}"
	if [ ${p:+x} ]; then
		file="$PWD/$file"
	fi
	realpath -se "$file"
done | awk -v "vroot=$root" \
	'BEGIN{vn=length(vroot)+1} substr($0,1,vn)==vroot"/"{print substr($0,vn+1)}'
