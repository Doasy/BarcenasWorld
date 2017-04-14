import sys



def parse(filename):
	steps = []
	with open(filename) as f:
		for line in f:
			line = map(int, line.split())
			steps.append(line)
	return steps

def write_intersections(pl):
	pl.write("intersectLocInfo( 0, _, 0 ).\n\
intersectLocInfo( _, 0, 0 ).\n\
intersectLocInfo( 1, Y, Y ).\n\
intersectLocInfo( X, 1, X ).\n\
intersectRow( [], [], [] ).\n\
intersectRow( [PH|PT], [NH|NT], [FH|FT] ) :-\n\
             intersectLocInfo( PH, NH, FH ),\n\
             intersectRow( PT, NT, FT ).\n\
intersectLocs( [], [], [] ).\n\
intersectLocs( [PrevRow|PrevLocs], [NewRow|NewLocs], FinalLocs ) :-\n\
             intersectRow( PrevRow, NewRow, FinalRow ),\n\
             intersectLocs( PrevLocs, NewLocs, RestOfRows ),\n\
             FinalLocs = [ FinalRow | RestOfRows ].\n")


def is_Barcenas_around(x, y, n):
	x-=1
	y-=1
	l= []
	for _ in xrange(n):
		l.append(list(1 for _ in xrange(n)))
	l[0][0] = 0
	l[x][y] = 0
	if x > 0:
		l[x-1][y]=0
	if x < n-1:
		l[x+1][y]=0
	if y > 0:
		l[x][y-1]=0
	if y < n-1:
		l[x][y+1]=0


def write_Barcenas_around(pl, n):
	for x in xrange(n):
		for y in xrange(n):
			write("iSBarcenasAround( "+str(x)+", "+str(y)+", 0" + str(is_Barcenas_around(x,y,n))+" ).")

if __name__ == "__main__":

	if len(sys.argv) != 3:
		print "error"
		sys.exit(-1) 
	
	n = int(sys.argv[1])

	steps = parse(sys.argv[2])
	pl = open("BarcenasWorld.pl", "w")
	write_intersections(pl)
	write_Barcenas_around(pl, n)



	pl.close()

	


	