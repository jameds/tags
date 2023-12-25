BEGIN {
	FS="\t"
	OFS="\t"
	p = length(vroot) + 2
}
$1!="/" {
	print NR "\t..."
	exit
}
{ print NR "\t" substr($3, p) }
