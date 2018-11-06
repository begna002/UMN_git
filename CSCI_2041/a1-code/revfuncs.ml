let array_rev arr =
  if Array.length arr > 2 then
    let len = Array.length arr in
    let i = ref 0 in
    let j = ref (len - 1) in
    while i < j do
      let x = arr.(!i) in
      let y = arr.(!j) in
      arr.(!i) <- y;
      arr.(!j) <- x;
      i := !i + 1;
      j := !j - 1;
    done;
;;


(* val array_rev : 'a array -> unit
   Reverses the given array in place. Uses iteration and mutation to
   do so efficiently. DOES NOT generate any internal copies of the
   parameter array.

   REPL EXAMPLES:
   # let a1 = [|1; 2; 3;|];;
   val a1 : int array = [|1; 2; 3|]
   # array_rev a1;;
   - : unit = ()
   # a1;;
   - : int array = [|3; 2; 1|]
   # let a2 = [|"a"; "b"; "c"; "d"; "e"; "f"|];;
   val a2 : string array = [|"a"; "b"; "c"; "d"; "e"; "f"|]
   # array_rev a2;;
   - : unit = ()
   # a2;;
   - : string array = [|"f"; "e"; "d"; "c"; "b"; "a"|]
   # let a3 = [|true; true; false; false; true;|];;
   val a3 : bool array = [|true; true; false; false; true|]
   # array_rev a3;;
   - : unit = ()
   # a3;;
   - : bool array = [|true; false; false; true; true|]
*)

let list_rev lst =
  let rec helper lst rev =
    if lst = [] then
      rev
    else
      let first = List.hd lst in
      let rest = List.tl lst in
      let rev = helper rest rev in
      rev @ [first]
  in
  helper lst []


;;
(* val list_rev : 'a list -> 'a list

   Return a reversed copy of the given list. Does not (and cannot)
   modify the original list. Uses an internal recursive function to
   build the reversed list. The internal function is tail-recursive.

   REPL EXAMPLES:
   # list_rev lst1;;
   - : int list = [3; 2; 1]
   # lst1;;
   - : int list = [1; 2; 3]
   # let lst2 = ["a"; "b"; "c"; "d"; "e"; "f"];;
   val lst2 : string list = ["a"; "b"; "c"; "d"; "e"; "f"]
   # list_rev lst2;;
   - : string list = ["f"; "e"; "d"; "c"; "b"; "a"]
   # lst2;;
   - : string list = ["a"; "b"; "c"; "d"; "e"; "f"]
   # let lst3 = [true; true; false; false; true];;
   val lst3 : bool list = [true; true; false; false; true]
   # list_rev lst3;;
   - : bool list = [true; false; false; true; true]
   # lst3;;
   - : bool list = [true; true; false; false; true]
*)
