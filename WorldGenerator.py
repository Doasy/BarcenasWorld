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
\n\
intersectRow( [], [], [] ).\n\
intersectRow( [PH|PT], [NH|NT], [FH|FT] ) :-\n\
             intersectLocInfo( PH, NH, FH ),\n\
             intersectRow( PT, NT, FT ).\n\
\n\
intersectLocs( [], [], [] ).\n\
intersectLocs( [PrevRow|PrevLocs], [NewRow|NewLocs], FinalLocs ) :-\n\
             intersectRow( PrevRow, NewRow, FinalRow ),\n\
             intersectLocs( PrevLocs, NewLocs, RestOfRows ),\n\
             FinalLocs = [ FinalRow | RestOfRows ].\n\n")


def is_Barcenas_around(x, y, n, smell):
    if smell == 0: opSmell = 1
    else: opSmell = 0
    x-=1
    y-=1
    l= []
    for _ in xrange(n):
        l.append(list(opSmell for _ in xrange(n)))
    l[0][0] = 0
    l[x][y] = smell
    if x > 0:
        l[x-1][y]=smell
    if x < n-1:
        l[x+1][y]=smell
    if y > 0:
        l[x][y-1]=smell
    if y < n-1:
        l[x][y+1]=smell
    return l

def write_with_semll_X(pl, n, smell):
    for x in xrange(1, n+1):
            for y in xrange(1, n+1):
                pl.write("iSBarcenasAround( "+str(x)+", "+str(y)+", "+str(smell)+", " +\
    str(is_Barcenas_around(x,y,n,smell))+" ).\n")

def write_Barcenas_around(pl, n):
    write_with_semll_X(pl, n, 0)
    pl.write("\n")
    write_with_semll_X(pl, n, 1)
    pl.write("\n")

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

    


    