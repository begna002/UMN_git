predicate(Value, true:[Value|Tail], false:Tail).
predicate(_Value, false:Tail, true:Tail).

oddOnly(List, LST) :-
 foldl(predicate, List, true:LST, _:[]).
