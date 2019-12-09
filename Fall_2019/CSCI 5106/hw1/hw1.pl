predicate(Value, true:[Value|Tail], false:Tail).
predicate(_Value, false:Tail, true:Tail).

oddOnly(List, LST) :-
 foldl(predicate, List, true:LST, _:[]).

permutation(L, R) :- sort(L, X), sort(R, X).

evenList(L) :- length(L, X), 0 is mod(X, 2).
