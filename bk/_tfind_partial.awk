function positive(t) {
	m=0
	for (k in tadd)
	{
		if (index(t, tadd[k]))
			m++
	}
	return tadd_n <= m
}

function negative(t) {
	for (k in tsub)
	{
		if (index(t, tsub[k]))
			return 0
	}
	return 1
}

BEGIN {
	tadd_n = split(vadd, tadd)
	tsub_n = split(vsub, tsub)
	tflag_n = split(vflag, _, "")
	for (k in _)
		tflag[_[k]]
	bverbose=("v" in tflag)
}

f {
	f=0
	print
}

NR%2 { # first line, third line... 1, 3, 5
	if (positive($0) && negative($0))
	{
		f=1
		if (bverbose)
			print
	}
}
