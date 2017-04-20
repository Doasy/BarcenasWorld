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

isBarcenasAround( 1, 2, 0, [[0, 0, 0], [1, 0, 1], [1, 1, 1]] ).
isBarcenasAround( 2, 2, 0, [[0, 0, 1], [0, 0, 0], [1, 0, 1]] ).
isBarcenasAround( 2, 3, 1, [[0, 0, 1], [0, 1, 1], [0, 0, 1]] ).

Lies :- 1
intersectLies(0, X, X).
intersectLies(-1, Y, Y).
intersectLies(1, 1, 0).
intersectLies(1, 0, 1).

intersectRowMarianoLies( Lies, [], [] ).
intersectRowMarianoLies( Lies, [PH|PT], [FH|FT] ) :-
             intersectLies( Lies, PH, FH ),
             intersectRowMarianoLies( Lies, PT, FT ).

intersectMarianoLies( Lies, [], [] ).
intersectMarianoLies( Lies, [PrevRow|PrevLocs], FinalLocs ) :-
             intersectRowMarianoLies( Lies, PrevRow, FinalRow ),
             intersectMarianoLies( Lies, PrevLocs, RestOfRows ),
             FinalLocs = [ FinalRow | RestOfRows ].

isBarcenasOnLeft( 2, 3, -1, [[0, 0, 1], [0, 0, 0], [0, 0, 1]] ).
isBarcenasOnLeft( 1, 2, 0, [[0, 1, 1], [0, 1, 1], [0, 1, 1]] ).
isBarcenasOnLeft( 2, 2, 1, [[0, 0, 0], [1, 0, 0], [1, 0, 0]] ).
updatePosBarcenasLocs( PrevLocs, AgentPosX, AgentPosY,  SmellXY, MarianoXY, FinalLocs )
   :-
      isBarcenasAround( AgentPosX, AgentPosY, SmellXY, AfterSmell ),
      intersectLocs( PrevLocs, AfterSmell, Locs ), !,
      isBarcenasOnLeft( AgentPosX, AgentPosY, MarianoXY, NewLocs ),
      intersectLocs( Locs, NewLocs, FinalLocs ), !,
      write( 'Estado resultante: ' ), write( FinalLocs ), nl.

updateSequenceOfSteps( FS, [], FS ):- write( 'Estado final: ' ), write(FS ), nl.

updateSequenceOfSteps( PrevLocs, [H|T], FS )
    :-
        nth0(0, H, X),
        nth0(1, H, Y),
        nth0(2, H, S),
        nth0(3, H, M),
        write([X,Y,S,M]),
        updatePosBarcenasLocs( PrevLocs, X, Y, S, M, NextLocs ),
        updateSequenceOfSteps( NextLocs, T, FS ).

