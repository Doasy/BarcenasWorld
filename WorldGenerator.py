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


def write_barcenas_around(pl, x, y, smell):
    pl.write("isBarcenasAround( " + str(x) + ", "
             + str(y) + ", " + str(smell) + ", " +
             str(is_Barcenas_around(x, y, smell)) + " ).\n")


def is_barcenas_on_left(x, y, n, left):
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


def write_barcenas_on_left(pl, n, x, y, left):
    pl.write("isBarcenasOnLeft( " + str(x) + ", " + str(y) +
             ", " + str(left) + ", " +
             str(is_barcenas_on_left(x, y, n, left)) + " ).\n")


def write_answers_of_mariano(pl, n, marianos_answers):
    # 1 true, Barcenas is on his left
    # 0 false, Barcenas isn't on his left
    # -1 NS/NC
    for step in marianos_answers:
        x, y, mariano = step
        write_barcenas_on_left(pl, n, x, y, mariano)


def walk(pl, steps, n):
    marianos_null_answers = []
    marianos_answers = []
    mariano_lies = -1
    for step in steps:
        x, y, smell, mariano, cospe = step
        write_barcenas_around(pl, x, y, smell)
        if mariano != -1:
            marianos_answers.append([x, y, mariano])
        else:
            marianos_null_answers.append([x, y, mariano])
        if cospe != -1:
            mariano_lies = cospe
    pl.write("\n")
    return mariano_lies, marianos_answers, marianos_null_answers


def write_update_pos_barcenas_locs(pl):
    pl.write("updatePosBarcenasLocs( PrevLocs, AgentPosX, AgentPosY,  SmellXY, MarianoXY, FinalLocs )\n\
   :-\n\
      isBarcenasAround( AgentPosX, AgentPosY, SmellXY, AfterSmell ),\n\
      intersectLocs( PrevLocs, AfterSmell, Locs ), !,\n\
      isBarcenasOnLeft( AgentPosX, AgentPosY, MarianoXY, NewLocs ),\n\
      intersectLocs( Locs, NewLocs, FinalLocs ), !,\n\
      write( 'Estado resultante: ' ), write( FinalLocs ), nl.\n\n")


def write_update_seq_of_steps(pl):
    pl.write("updateSequenceOfSteps( FS, [], FS ):- write( 'Estado final: ' ), write(FS ), nl.\n\n")
    pl.write("updateSequenceOfSteps( PrevLocs, [H|T], FS )\n\
    :-\n\
        nth0(0, H, X),\n\
        nth0(1, H, Y),\n\
        nth0(2, H, S),\n\
        nth0(3, H, M),\n\
        write([X,Y,S,M]),\n\
        updatePosBarcenasLocs( PrevLocs, X, Y, S, M, NextLocs ),\n\
        updateSequenceOfSteps( NextLocs, T, FS ).\n\n")


def write_answers_of_cospedal(pl, mariano_lies):
    pl.write("Lies :- " + str(mariano_lies) + "\n")
    pl.write("intersectLies(0, X, X).\n\
intersectLies(-1, Y, Y).\n\
intersectLies(1, 1, 0).\n\
intersectLies(1, 0, 1).\n\n")
    pl.write("intersectRowMarianoLies( Lies, [], [] ).\n\
intersectRowMarianoLies( Lies, [PH|PT], [FH|FT] ) :-\n\
             intersectLies( Lies, PH, FH ),\n\
             intersectRowMarianoLies( Lies, PT, FT ).\n\n")
    pl.write("intersectMarianoLies( Lies, [], [] ).\n\
intersectMarianoLies( Lies, [PrevRow|PrevLocs], FinalLocs ) :-\n\
             intersectRowMarianoLies( Lies, PrevRow, FinalRow ),\n\
             intersectMarianoLies( Lies, PrevLocs, RestOfRows ),\n\
             FinalLocs = [ FinalRow | RestOfRows ].\n\n")


if __name__ == "__main__":

    if len(sys.argv) != 3:
        print "error"
        sys.exit(-1)

    n = int(sys.argv[1])

    steps = parse(sys.argv[2])
    print steps
    pl = open("BarcenasWorld.pl", "w")
    pl.write(":- use_module(library(lists)).\n\n")
    write_intersections(pl)
    mariano_lies, marianos_answers, marianos_null_answers = walk(pl, steps, n)
    write_answers_of_cospedal(pl, mariano_lies)
    write_answers_of_mariano(pl, n, marianos_null_answers)
    write_answers_of_mariano(pl, n, marianos_answers)
    write_update_pos_barcenas_locs(pl)
    write_update_seq_of_steps(pl)

    pl.close()
