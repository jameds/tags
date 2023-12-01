#!/bin/sh
tfind.sh $* | xargs -d '\n' viewnior /dev/null
