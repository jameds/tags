#!/bin/sh
root="$(_get.sh root)"
if [ "$(echo "$1" | tr -cd v)" ]; then
	awk -v "vroot=$root/" 'NR%2==0{print "  "vroot $0;next}1'
else
	awk -v "vroot=$root/" '{print vroot $0}'
fi
