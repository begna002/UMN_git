/* Problem 4.1: In order to describe an abstract syntax representation for
logical expressions, we can use a linear notation in which, using
the following predicates, we can define the logical operators and, or, not. Thus,
we can represent logical expresions such as and(not(A), or(A, B))*/

and(A,B):- A, B.
or(A,B):- A; B.
not(A):- \+ A.

/* Problem 4.2:  The assignment of truth values for propositional variables
 within a logical expression can be represented as a list of "tuples" containing
 the name of the variable and the truth assignment for it. As an example,
 [(p, true), (q, true)] is an assignment list whereby the propositional
 variables q and p within some given expression both have the value true.*/

/*Problem 3.3 A function that returns the truth value of a logical Expression E
 and an assignment L of truth values for propositional variables.*/

istrue(and(A,B), L):- and(istrue(A, L), istrue(B, L)).
istrue(or(A,B), L):- or(istrue(A, L), istrue(B, L)).
istrue(not(A), L):- not(istrue(A, L)).
istrue(var(A), L):- member((A, true), L).

/*Problem 3.4 A function that takes a logical expression and returns a list of
 all the propositional variables appearing in that list. */
varsInExp(and(A,B), LST):- varsInExp(A,ALIST), varsInExp(B,BLST), union(ALIST,BLST,LST).
varsInExp(or(A,B), LST):- varsInExp(A,ALIST), varsInExp(B,BLST), union(ALIST,BLST,LST).
varsInExp(not(A), LST):- varsInExp(A,ALIST), union([],ALIST,LST).
varsInExp(var(A), LST):- union([], [A], LST).

assignment([],[], _).
assignment([H|T1],[H:B|T2], V):- member(B, V), assignment(T1,T2,V).



visit_pairs([]).               % same as: %  visit_pairs([]).
visit_pairs([(A, B) | Xs]) :-  %   -->    %  visit_pairs([X|Xs]) :-
    writeln(value(A)),    %          %      (A, B) = X,
    writeln(value(B)),   %          %      writeln(first_pair(A)),
    visit_pairs(Xs).           %          %      writeln(second_pair(B)),
                               %          %      visit_pairs(Xs).


lastValue(LST, X) :- append([_|_], [X], LST).
