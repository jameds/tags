#!/bin/bash
_tfind_completions() {
	mapfile -t COMPREPLY < <(_complete.sh "$2")
}
complete -F _tfind_completions tfind.sh
complete -F _tfind_completions tview.sh
complete -F _tfind_completions tplay.sh
