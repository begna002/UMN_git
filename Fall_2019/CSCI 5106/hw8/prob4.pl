/* Problem 4.1: In order to describe an abstract syntax representation for
logical expressions, we can use a linear notation in which, using
the following predicates, we can define the logical operators and, or, not. Thus,
we can represent logical expresions such as and(not(A), or(A, B))*/

and(E1,E2):- E1, E2.
or(E1,E2):- E1; E2.
not(E):- \+ E.

/* Problem 4.2:  The assignment of truth values for propositional variables
 within a logical expression can be represented as a list of "tuples" containing
 the name of the variable and the truth assignment for it. As an example,
 [(p, true), (q, true)] is an assignment list whereby the propositional
 variables q and p within some given expression both have the value true.*/

/*Problem 4.3 A function that returns the truth value of a logical Expression E
 and an assignment L of truth values for propositional variables. Example,
 istrue(and(var(a), not(var(b))), [(a, true), (b, false)]) returns true.*/

istrue(E, L):- evaluate(E, L).

evaluate(and(E1,E2), L):- and(evaluate(E1, L), evaluate(E2, L)).
evaluate(or(E1,E2), L):- or(evaluate(E1, L), evaluate(E2, L)).
evaluate(not(E), L):- not(evaluate(E, L)).
evaluate(var(E), L):- member((E, true), L).

/*Problem 4.4 A function that takes a logical expression E and returns a list of
 all the propositional variables appearing in that list. */

varsOf(E, LST):- varList(E, LST).

varList(and(E1,E2), LST):- varList(E1,E1LIST), varList(E2,E2LST), union(E1LIST,E2LST,LST).
varList(or(E1,E2), LST):- varList(E1,E1LIST), varList(E2,E2LST), union(E1LIST,E2LST,LST).
varList(not(E), LST):- varList(E,ELIST), union([],ELIST,LST).
varList(var(E), LST):- union([], [E], LST).


/*Problem 4.5 A tautology function that takes a logical expression E and returns
true if every assignment for the expression evaluates to true*/

isTaut(E) :- not(isNotTaut(E)).
isNotTaut(E) :- varsOf(E, Varlist), assignment(Varlist, L, [true, false]), not(istrue(E, L)).

assignment([],[], TFLIST).
assignment([VAR|VARLIST],[(VAR, ASSGN)|T2], TFLIST):- member(ASSGN, TFLIST), assignment(VARLIST,T2,TFLIST).
