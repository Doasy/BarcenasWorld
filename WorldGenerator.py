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


def is_Barcenas_around(x, y, smell):
    if smell == 0:
        opSmell = 1
    else:
        opSmell = 0
    x -= 1
    y -= 1
    l = []
    for _ in xrange(n):
        l.append(list(opSmell for _ in xrange(n)))
    l[0][0] = 0
    l[x][y] = smell
    if x > 0:
        l[x - 1][y] = smell
    if x < n - 1:
        l[x + 1][y] = smell
    if y > 0:
        l[x][y - 1] = smell
    if y < n - 1:
        l[x][y + 1] = smell
    return l


def  write_Barcenas_around(pl, x, y, smell):
    pl.write("isBarcenasAround( " + str(x) + ", "
             + str(y) + ", " + str(smell) + ", " +
             str(is_Barcenas_around(x, y, smell)) + " ).\n")


def is_Barcenas_on_left(x, y, n, left):
    x -= 1
    y -= 1
    l = []
    for _ in xrange(n):
        l.append(list(1 for _ in xrange(n)))
    l[x][y] = (left + 1) % 2
    l[0][0] = 0
    if left == 1:
        for row in l:
            for column in xrange(y, n):
                row[column] = 0
    else:
        for row in l:
            for column in xrange(0, y):
                row[column] = 0

    return l


def write_Barcenas_on_left(pl, n, x, y, left):
    pl.write("isBarcenasOnLeft( " + str(x) + ", " + str(y) +
             ", " + str(left) + ", " +
             str(is_Barcenas_on_left(x, y, n, left)) + " ).\n")


def write_answers_of_Mariano(pl, n, mariano_lies, marianos_answers):
    # 1 true, Barcenas is on his left
    # 0 false, Barcenas isn't on his left
    for step in marianos_answers:
        x, y, mariano = step
        write_Barcenas_on_left(pl, n, x, y, (mariano+mariano_lies)%2)

def write_null_answers_of_Mariano(pl, n, marianos_null_answers):
    for step in marianos_null_answers:
        x, y, mariano = step
        write_Barcenas_on_left(pl, n, x, y, mariano)

def walk(pl, steps, n):
    marianos_null_answers = []
    marianos_answers = []
    mariano_lies = False
    for step in steps:
        x, y, smell, mariano, cospe = step
        write_Barcenas_around(pl, x, y, smell)
        if mariano != -1:
            marianos_answers.append([x, y, mariano])
        else:
            marianos_null_answers.append([x, y, mariano])
        if cospe != -1:
            mariano_lies = cospe
    pl.write("\n")
    return mariano_lies, marianos_answers, marianos_null_answers


        


if __name__ == "__main__":

    if len(sys.argv) != 3:
        print "error"
        sys.exit(-1)

    n = int(sys.argv[1])

    steps = parse(sys.argv[2])
    print steps
    pl = open("BarcenasWorld.pl", "w")
    write_intersections(pl)
    mariano_lies, marianos_answers, marianos_null_answers = walk(pl, steps, n)
    write_null_answers_of_Mariano(pl, n, marianos_null_answers)
    write_answers_of_Mariano(pl, n, mariano_lies, marianos_answers)

    pl.close()
