{
	split($0, tfind)
	n=length(vtag)
	for (k in tfind)
	{
		if (substr(tfind[k], 1, n) == vtag)
		{
			print vprefix tfind[k]
		}
	}
	exit
}
