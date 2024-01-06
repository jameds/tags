#!/bin/sh
_tags.sh | sort -u | awk '
/\./ {
	s = $0
	while (sub(/\.[^.]+\.?$/, ".", s))
		t[s]
} 1
END {
	for (k in t)
		print k
}
'
