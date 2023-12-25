BEGIN { FS="\t" }
$1!="/" { print $3 }
