BEGIN {
	root_n = length(vroot)
}

f {
	f=0

	if (substr($0, 1, root_n) == vroot)
	{
		if (bverbose)
			print tags
		print vprefix $0
	}
}

NR%2 { # first line, third line... 1, 3, 5
	if (compare())
	{
		f=1
		if (bverbose)
			tags=$0
	}
}
