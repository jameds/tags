{
	if (NR == FNR)
		Table[substr($0, vskip)] = substr($0, 1, vskip - 1)
	else
		delete Table[$0]
}

END {
	for (k in Table)
		print Table[k] k
}
