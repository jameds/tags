function positive(t) {
	m=0
	for (k in t)
	{
		if (t[k] in tadd)
			m++
	}
	return tadd_n <= m
}

function negative(t) {
	for (k in t)
	{
		if (t[k] in tsub)
			return 0
	}
	return 1
}

BEGIN {
	tadd_n = split(vadd, _)
	for (k in _)
		tadd[_[k]]
	tsub_n = split(vsub, _)
	for (k in _)
		tsub[_[k]]
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
	split($0, tags)
	if (positive(tags) && negative(tags))
	{
		f=1
		if (bverbose)
			print
	}
}
