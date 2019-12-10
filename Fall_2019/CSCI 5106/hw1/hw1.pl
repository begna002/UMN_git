oddOnly([], LST) :- append([], [], LST).
oddOnly([A], LST) :- append([A], [], LST).
oddOnly([A,_| T], LST) :- oddOnly(T, TLST), append([A], TLST, LST).

permutation(L, R) :- sort(L, X), sort(R, X).

evenList(L) :- length(L, X), 0 is mod(X, 2).

and(A,B):- A, B.
or(A,B):- A; B.
not(A):- \+ A.

checker(X):- not(X).
