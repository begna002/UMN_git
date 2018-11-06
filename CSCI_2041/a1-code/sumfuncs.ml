let array_sum arr =
  let count = ref 0 in
  let len = Array.length arr in
  for i = 0 to len - 1 do
    count := !count + arr.(i)
  done;
  !count;;

(* val array_sum : int array -> int
   Return the sum of int array arr. Uses Array.length to calculate its
   length. Uses a ref to a summing int and a loop over the array
   elements.

   REPL EXAMPLES:
   # array_sum [|1; 3; 5|];;
   - : int = 9
   # array_sum [|4; -3; 12; 2|];;
   - : int = 15
   # array_sum [||];;
   - : int = 0
*)

let rec list_sum lst =
  if lst = [] then
    0
  else
    let first = List.hd lst in
    let rest = List.tl lst in
    let total = list_sum rest in
    total + first


;;
(* val list_sum : int list -> int
   Return the sum of int list lst. Uses recursion and NO mutation.
   Uses List.hd and List.tl to get the head and tail of a list.

   REPL EXAMPLES:
   # list_sum [1; 3; 5];;
   - : int = 9
   # list_sum [4; -3; 12; 2];;
   - : int = 15
   # list_sum [];;
   - : int = 0
*)
