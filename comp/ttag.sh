#!/bin/bash
_ttag_completions() {
	local cur
	_get_comp_words_by_ref -n : cur

	h="$COMP_LINE "
	r="${h#*: }"
	p=$(( ${#h} - ${#r} ))

	if (( p == 0 )) || (( COMP_POINT < p )); then
		(( p == 0 )) && f=: || f=
		local IFS=$'\n'
		COMPREPLY=($(compgen -f "$cur"))
		if [ "$cur" == ':' ]; then
			COMPREPLY+=(:)
		else
			if [ "$cur" == '' ]; then
				COMPREPLY+=(:)
			fi
			compopt -o filenames
		fi
	else
		mapfile -t COMPREPLY < <(_complete.sh "$cur")
	fi

	__ltrim_colon_completions "$cur"
}
complete -F _ttag_completions ttag.sh
