
def	str2int(bs):
	bs = bs[::-1]
	t = 1
	rint = 0
	for i in bs:
		rint += int(i) * t
		t = t * 2
	return rint 

result = 'result.dat'
rfile = open(result)

t = rfile.readline() 
while t:
	tlist = t.split()
	l_div = tlist[0]
	l_qui = tlist[1]
	l_rem = tlist[2]
	div = str2int(l_div)
	qui = str2int(l_qui)
	rem = str2int(l_rem)

	t = 2**26 - div*qui - rem
	print t
	t = rfile.readline() 
