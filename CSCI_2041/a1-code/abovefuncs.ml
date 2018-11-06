let array_above thresh arr =
  let len = Array.length arr in
  let length = ref 0 in
  for i = 0 to len - 1 do
    if arr.(i) > thresh then
        length := !length + 1
  done;
  let newr = Array.make !length thresh in
  let count = ref 0 in
  for i = 0 to len - 1 do
    if arr.(i) > thresh then
      let x = arr.(i) in
      newr.(!count) <- x;
      count := !count + 1
  done;
  newr
;;
(* val array_above : 'a -> 'a array -> 'a array

   Creates a new array which has only elements which are greater than
   parameter thresh in it. Elements from arr that are larger than
   thresh appear in the same order the return array as they do in arr.
   Uses two passes to count the elements above in arr, allocates
   another array of appropriate size, and then copies in elements from
   arr.  Does not modify the original array arr.

   REPL EXAMPLES:
   # array_above 0 [|0; 1; 2; 0|];;
   - : int array = [|1; 2|]
   # array_above 0 [|4; -2; -1; 7; 0; 3|];;
   - : int array = [|4; 7; 3|]
   # array_above 3 [|4; -2; -1; 7; 0; 3|];;
   - : int array = [|4; 7|]
   # array_above 1.5 [|4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5|];;
   - : float array = [|4.2; 7.6; 8.9; 8.5|]
   # array_above 0.0 [|4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5|];;
   - : float array = [|4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5|]
   # array_above 9.0 [|4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5|];;
   - : float array = [||]
   # array_above false [|false; true; false; true; true;|];;
   - : bool array = [|true; true; true|]
*)

let rec list_above thresh lst =
  if lst = [] then
    []
  else
    let first = List.hd lst in
    let rest = List.tl lst in
    if first <= thresh then
        list_above (thresh) (rest)
    else
      let newl = list_above (thresh) (rest) in
      first :: newl
;;
(* val list_above : 'a -> 'a list -> 'a list

   Create a list which has only elements from lst that are larger than
   thresh.  Uses recursion to accomplish this in a single pass over
   the original list. Does not modify the original list lst.

   REPL EXAMPLES:
   # list_above 0 [0; 1; 2];;
   - : int list = [1; 2]
   # list_above 0 [0; 1; 2; 0];;
   - : int list = [1; 2]
   # list_above 0 [4; -2; -1; 7; 0; 3];;
   - : int list = [4; 7; 3]
   # list_above 3 [4; -2; -1; 7; 0; 3];;
   - : int list = [4; 7]
   # list_above 1.5 [4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5];;
   - : float list = [4.2; 7.6; 8.9; 8.5]
   # list_above 0.0 [4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5];;
   - : float list = [4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5]
   # list_above 9.0 [4.2; 0.5; 1.2; 7.6; 8.9; 0.8; 8.5];;
   - : float list = []
   # list_above false [false; true; false; true; true;];;
   - : bool list = [true; true; true]
*)
