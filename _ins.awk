BEGIN {
	tls_n = asoc(vls, tls, "\n")
	if (!tls_n)
		exit 1
}

{
	if (NR%2)
		tags=$0
	else
	{
		if ($0 in tls)
		{
			print tags
			print

			delete tls[$0]
			if (!--tls_n)
				exit
		}
	}
}

END {
	for (file in tls)
	{
		print "NO_FILE"
		print file
	}
}
