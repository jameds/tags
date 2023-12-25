BEGIN { FS="\t" }
NR==+vn {
	if ($1 == "/")
	{
		print $3
		exit
	}
	else
	{
		f=1
	}
}
f { print $3 }
