#!/bin/sh
tfind.sh $* | xargs -r -d '\n' viewnior /dev/null
