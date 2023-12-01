BEGIN {
	tadd_n = split(vadd, tadd)
	tsub_n = asoc(vsub, tsub)
	tls_n = asoc(vls, tls, "\n")
	og_tls = tls_n
}

{
	if (!tls_n)
		print
	else if (NR%2)
		tags=$0
	else
	{
		if ($0 in tls)
		{
			asoc(tags, tab, " ")
			for (p in tsub)
			{
				for (s in tab)
				{
					if (substr(s, 1, length(p)) == p)
					{
						delete tab[s]
					}
				}
			}
			for (k in tadd) tab[tadd[k]]
			tags = ""
			for (k in tab) tags = tags " " k
			tags = substr(tags, 2)

			delete tls[$0]
			tls_n--;
		}

		print tags
		print
	}
}

END {
	if (vtty)
		print og_tls - tls_n " changed, " tls_n " new" > vtty
	if (tls_n)
	{
		sub(/^ */, "", vadd)
		sub(/ *$/, "", vadd)
		for (file in tls)
		{
			print vadd
			print file
		}
	}
}
