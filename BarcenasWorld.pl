:- style_check(-singleton).
:- use_module(library(lists)).

intersectLocInfo( 0, _, 0 ).
intersectLocInfo( _, 0, 0 ).
intersectLocInfo( 1, Y, Y ).
intersectLocInfo( X, 1, X ).

intersectRow( [], [], [] ).
intersectRow( [PH|PT], [NH|NT], [FH|FT] ) :-
             intersectLocInfo( PH, NH, FH ),
             intersectRow( PT, NT, FT ).

intersectLocs( [], [], [] ).
intersectLocs( [PrevRow|PrevLocs], [NewRow|NewLocs], FinalLocs ) :-
             intersectRow( PrevRow, NewRow, FinalRow ),
             intersectLocs( PrevLocs, NewLocs, RestOfRows ),
             FinalLocs = [ FinalRow | RestOfRows ].

isBarcenasAround( 6, 2, 0, [[0, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1], [1, 0, 1, 1, 1, 1], [0, 0, 0, 1, 1, 1]] ).
isBarcenasAround( 5, 4, 0, [[0, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 0, 1, 1], [1, 1, 0, 0, 0, 1], [1, 1, 1, 0, 1, 1]] ).
isBarcenasAround( 3, 5, 0, [[0, 1, 1, 1, 1, 1], [1, 1, 1, 1, 0, 1], [1, 1, 1, 0, 0, 0], [1, 1, 1, 1, 0, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1]] ).

intersectLies( -1, X, 1, 1).
intersectLies( M, 1, 1, 0).
intersectLies( M, 1, 0, 1).
intersectLies( M, 0, X, X).
intersectLies( M, -1, Y, Y).

intersectRowMarianoLies( M, Lies, [], [] ).
intersectRowMarianoLies( M, Lies, [PH|PT], [FH|FT] ) :-
             intersectLies( M, Lies, PH, FH ),
             intersectRowMarianoLies( M, Lies, PT, FT ).

intersectMarianoLies( M, Lies, [], [] ).
intersectMarianoLies( M, Lies, [PrevRow|PrevLocs], FinalLocs ) :-
             intersectRowMarianoLies( M, Lies, PrevRow, FinalRow ),
             intersectMarianoLies( M, Lies, PrevLocs, RestOfRows ),
             FinalLocs = [ FinalRow | RestOfRows ].

isBarcenasOnLeft( 6, 2, 0, [[0, 1, 1, 1, 1, 1], [0, 1, 1, 1, 1, 1], [0, 1, 1, 1, 1, 1], [0, 1, 1, 1, 1, 1], [0, 1, 1, 1, 1, 1], [0, 1, 1, 1, 1, 1]] ).
isBarcenasOnLeft( 5, 4, 0, [[0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1]] ).
isBarcenasOnLeft( 3, 5, 0, [[0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 1, 1]] ).

updatePosBarcenasLocs( PrevLocs, AgentPosX, AgentPosY,  SmellXY, MarianoXY, Cospedal, FinalLocs )
   :-
      isBarcenasAround( AgentPosX, AgentPosY, SmellXY, AfterSmell ),
      intersectLocs( PrevLocs, AfterSmell, Locs ), !,
      isBarcenasOnLeft( AgentPosX, AgentPosY, MarianoXY, MarianoLocs ),
      intersectMarianoLies( MarianoXY, Cospedal, MarianoLocs, NewLocs ),
      intersectLocs( Locs, NewLocs, FinalLocs ), !, nl.

writeFinalState( [] ).
writeFinalState( [F|FS] ):-
        write(F),
        write('
'),
        writeFinalState(FS).

set(N, Lies) :- Lies is N.

updateSequenceOfSteps( FS, [], FS ):- write( 'Estado final: 
' ), writeFinalState(FS), nl.

updateSequenceOfSteps( PrevLocs, [H|T], FS )
    :-
        set( 0, Lies ),
        nth0(0, H, X),
        nth0(1, H, Y),
        nth0(2, H, S),
        nth0(3, H, M),
        updatePosBarcenasLocs( PrevLocs, X, Y, S, M, Lies,NextLocs ),
        write( 'Estado resultante: 
' ), writeFinalState(NextLocs), nl, 
        updateSequenceOfSteps( NextLocs, T, FS ).

