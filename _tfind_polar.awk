function positive() {
	m=0
	for (k in tadd)
	{
		if (index($0, tadd[k]))
			m++
	}
	return tadd_n <= m
}

function negative() {
	for (k in tsub)
	{
		if (index($0, tsub[k]))
			return 0
	}
	return 1
}

function compare() {
	return positive() && negative()
}

BEGIN {
	tadd_n = split(vadd, tadd)
	tsub_n = split(vsub, tsub)
}
