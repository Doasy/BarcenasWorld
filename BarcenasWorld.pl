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

iSBarcenasAround( 1, 1, 0, [[0, 0, 1], [0, 1, 1], [1, 1, 1]] ).
iSBarcenasAround( 1, 2, 0, [[0, 0, 0], [1, 0, 1], [1, 1, 1]] ).
iSBarcenasAround( 1, 3, 0, [[0, 0, 0], [1, 1, 0], [1, 1, 1]] ).
iSBarcenasAround( 2, 1, 0, [[0, 1, 1], [0, 0, 1], [0, 1, 1]] ).
iSBarcenasAround( 2, 2, 0, [[0, 0, 1], [0, 0, 0], [1, 0, 1]] ).
iSBarcenasAround( 2, 3, 0, [[0, 1, 0], [1, 0, 0], [1, 1, 0]] ).
iSBarcenasAround( 3, 1, 0, [[0, 1, 1], [0, 1, 1], [0, 0, 1]] ).
iSBarcenasAround( 3, 2, 0, [[0, 1, 1], [1, 0, 1], [0, 0, 0]] ).
iSBarcenasAround( 3, 3, 0, [[0, 1, 1], [1, 1, 0], [1, 0, 0]] ).

iSBarcenasAround( 1, 1, 1, [[1, 1, 0], [1, 0, 0], [0, 0, 0]] ).
iSBarcenasAround( 1, 2, 1, [[1, 1, 1], [0, 1, 0], [0, 0, 0]] ).
iSBarcenasAround( 1, 3, 1, [[0, 1, 1], [0, 0, 1], [0, 0, 0]] ).
iSBarcenasAround( 2, 1, 1, [[1, 0, 0], [1, 1, 0], [1, 0, 0]] ).
iSBarcenasAround( 2, 2, 1, [[0, 1, 0], [1, 1, 1], [0, 1, 0]] ).
iSBarcenasAround( 2, 3, 1, [[0, 0, 1], [0, 1, 1], [0, 0, 1]] ).
iSBarcenasAround( 3, 1, 1, [[0, 0, 0], [1, 0, 0], [1, 1, 0]] ).
iSBarcenasAround( 3, 2, 1, [[0, 0, 0], [0, 1, 0], [1, 1, 1]] ).
iSBarcenasAround( 3, 3, 1, [[0, 0, 0], [0, 0, 1], [0, 1, 1]] ).

