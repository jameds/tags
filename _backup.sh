#!/bin/sh
old="$(stat -c %Y "$TAG_HOME/map.bk")"
new="$(date +%s)"
if (( (new - old) > 60*60 )); then
	cp "$TAG_HOME/map" "$TAG_HOME/map.bk"
fi
