/* :- use_module(library(clpfd)).  */

read_animal(X) :-
  write('please type animal name:'),
  nl,
  read(X),
  animal(X).

/*
 Simple Barcenas World:

  3 x 3 grid, each one can generate a smell signal

  Rule :
                                                        i+1,j
    smell in i,j => Barcenas can be in locations  i,j-1  i,j  i,j+1
                                                        i-1,j
    except in initial location of the agent: (1,1)
*/

/* Intersect Prev Info about a location of Barcenas (first argument)
   with a new Info for the same location (second argument). The resulting updated
   information for the location is in the third argument.
   Observe that with this "programming" of intersectLocInfo some answers can be
   obtained in different ways. */

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


/* isBarcenasAround when Smell = 0, gives as possible locs
 only the ones not around the current pos   !!! */


isBarcenasAround( 1, 1, 0, [[0,0,1],[0,1,1],[1,1,1]] ).
isBarcenasAround( 1, 2, 0, [[0,0,0],[1,0,1],[1,1,1]] ).
isBarcenasAround( 1, 3, 0, [[0,0,0],[1,1,0],[1,1,1]] ).
isBarcenasAround( 2, 1, 0, [[0,1,1],[0,0,1],[0,1,1]] ).
isBarcenasAround( 2, 2, 0, [[0,0,1],[0,0,0],[1,0,1]] ).
isBarcenasAround( 2, 3, 0, [[0,1,0],[1,0,0],[1,1,0]] ).
isBarcenasAround( 3, 1, 0, [[0,1,1],[0,1,1],[0,0,1]] ).
isBarcenasAround( 3, 2, 0, [[0,1,1],[1,0,1],[0,0,0]] ).
isBarcenasAround( 3, 3, 0, [[0,1,1],[1,1,0],[1,0,0]] ).

/* isBarcenasAround when Smell = 1, gives as possible locs only the ones around
    the agent current position  */
isBarcenasAround( 1, 1, 1, [[0,1,0],[1,0,0],[0,0,0]] ).
isBarcenasAround( 1, 2, 1, [[0,1,1],[0,1,0],[0,0,0]] ).
isBarcenasAround( 1, 3, 1, [[0,1,1],[0,0,1],[0,0,0]] ).
isBarcenasAround( 2, 1, 1, [[0,0,0],[1,1,0],[1,0,0]] ).
isBarcenasAround( 2, 2, 1, [[0,1,0],[1,1,1],[0,1,0]] ).
isBarcenasAround( 2, 3, 1, [[0,0,1],[0,1,1],[0,0,1]] ).
isBarcenasAround( 3, 1, 1, [[0,0,0],[1,0,0],[1,1,0]] ).
isBarcenasAround( 3, 2, 1, [[0,0,0],[0,1,0],[1,1,1]] ).
isBarcenasAround( 3, 3, 1, [[0,0,0],[0,0,1],[0,1,1]] ).

/*  From the list of prev possible locs of Barcenas in PrevLocs,
    and the new info from agent (X,Y,Smell) get the
     new set of possible locations in FinalLocs

For example, starting from the initial state where every location
, except 1,1, is possible:
 updatePosBarcenasLocs( [[0,1,1],[1,1,1],[1,1,1]], 1, 1, 0, F ).
 we get F = [[0,0,1],[0,1,1],[1,1,1]]

if we next  move to 1,2 and it still does not smell:
 updatePosBarcenasLocs( [[0,0,1],[0,1,1],[1,1,1]], 1, 2, 0, F ).
 we get as the next state F:
   F =  [[0,0,0],[0,0,1],[1,1,1]]

 if we next move to 2,2 and it still does not smell:
 updatePosBarcenasLocs( [[0,0,0],[0,0,1],[1,1,1]], 2, 2, 0, F ).
 we get as the next state F:
   F =  [[0,0,0],[0,0,0],[1,0,1]]

   We can execute a query where we execute a sequence of consecutive steps, where the
    resulting state of a step is the previous state for the next step, in the following
    way (it must be put in the prolog interpreter in a SINGLE line):

     updatePosBarcenasLocs( [[0,1,1],[1,1,1],[1,1,1]], 1, 1, 0, F1 ),
      updatePosBarcenasLocs( F1, 1, 2, 0, F2 ),
       updatePosBarcenasLocs( F2, 2, 2, 0, F3 ),
         updatePosBarcenasLocs( F3, 2, 3, 1, F4 ).

  In this example query, we are executing the sequence of steps (with smell readings:)

  1,1,0
  1,2,0
  2,2,0
  2,3,1

  that gives as final state:

  F4 = [[0, 0, 0], [0, 0, 0], [0, 0, 1]]

  Try to program a recursive predicate, called execSeqofSteps( [Step1,Step2, ... , StepN], FinalState ),
   that given a list of steps with the format:

    [Step1,Step2, ... , StepN]  where each step is also a list: [X,Y,SmellValue]

    it will execute that sequence of steps starting from the initial state
     [[0,1,1],[1,1,1],[1,1,1]]

*/

updatePosBarcenasLocs( PrevLocs, AgentPosX, AgentPosY,  SmellXY, FinalLocs )
   :-
      isBarcenasAround( AgentPosX, AgentPosY, SmellXY, NewLocs ),
      intersectLocs( PrevLocs, NewLocs, FinalLocs ), !,
      write( 'Estado resultante: ' ), write( FinalLocs ), nl.

/* In this updatePosBarcenasLocs, there is a strange predicate symbol: ! . It is
used to "cut" the many possible alternative proof branches that can be obtained because
for some answers the predicate intersectLocs can give the same answer with different
resolution proofs, and because we are not interested in obtaining the same answer with
different branches we can cut the secondary ones with this symbol, that breaks off
the backtracking that would allow  intersectLocs to be resolved in more  than one way.
Try to erase the ! symbol and observe that now the interpreter will give you the same
answer different times.  */
