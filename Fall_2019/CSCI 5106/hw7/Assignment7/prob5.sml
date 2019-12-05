(*PROBLEM 5*)
(*Pre-defined Fibonacci function that was from the assignment*)

fun fib 0 = 0
  | fib 1 = 1
  | fib n = (fib (n-1)) + (fib (n-2))
;

(*Prob 5.1: A Fibonacci function derived by a continuation-passing style
 transformation of the earlier pre-defined function*)

fun fibcc 0 c = (c 0)
 | fibcc 1 c = (c 1)
 | fibcc n c = (fibcc(n-1) (fn x => fibcc (n-2) (fn y => c (x + y))))
;

(*Prob 5.2: Testing fibcc relative to fib*)

fib 4;
(*Result: 3*)
fibcc 4 (fn x => x);
(*Result: 3*)

fib 11;
(*Result: 89*)
fibcc 11 (fn x => x);
(*Result: 89*)
