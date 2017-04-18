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

isBarcenasOnLeft( 2, 3, -1, [[0, 0, 1], [0, 0, 0], [0, 0, 1]] ).
isBarcenasOnLeft( 1, 2, 1, [[0, 0, 0], [1, 0, 0], [1, 0, 0]] ).
isBarcenasOnLeft( 2, 2, 0, [[0, 1, 1], [0, 1, 1], [0, 1, 1]] ).

updatePosBarcenasLocs( PrevLocs, AgentPosX, AgentPosY,  SmellXY, MarianoXY, FinalLocs )
   :-
      isBarcenasAround( AgentPosX, AgentPosY, SmellXY, AfterSmell ),
      intersectLocs( PrevLocs, AfterSmell, Locs ), !,
	  isBarcenasOnLeft( AgentPosX, AgentPosY, MarianoXY, NewLocs ),
	  intersectLocs( PrevLocs, NewLocs, FinalLocs ), !,
      write( 'Estado resultante: ' ), write( FinalLocs ), nl.

/*execSeqofSteps( [Step1,Step2, ... , StepN], FinalState ),*/
/*execSeqofSteps( [[0,1,1],[1,1,1],[1,1,1]], [[1, 2, 0, 0, -1], [2, 2, 0, 1, 1], [2, 3, 1, -1, -1]], FS ).*/
execSeqofSteps( _,[],FS ):-write( 'Estado resultante: ' ), write(FS FS ), nl.
execSeqofSteps( PrevLocs, [H|T], FS )
	:-
		nth0(0, H, X),
		nth0(1, H, Y),
		nth0(2, H, S),
		nth0(3, H, M),
		updatePosBarcenasLocs( PrevLocs, X, Y,  S, M, FinalLocs ),
		execSeqogSteps(FinalLocs, T, FinalLocs )
