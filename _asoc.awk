function asoc(v, t, s,    n,    _) {
	n = split(v, _, s != 0 ? s : " ")
	for (k in _) t[_[k]]
	return n
}
