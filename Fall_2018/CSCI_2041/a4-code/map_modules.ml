(* map_modules.ml: provides two modules for maps.
   1. StringStringMap which maps strings to strings
   2. IntpairBoolMap which maps pairs of ints to bools.
   Both modules are created by creating a short module adhering to the
   Treemap.KEYVAL_SIG signature and then invoking the Treemap.Make
   functor. *)

open Printf;;

(* Interface module for maps of string to string *)
module StringStringKV = struct
  type key_t = string;;
  type value_t = string;;
  let compare_keys x y = String.compare x y;;
  let keyval_string k v = sprintf "{%s -> %s}" k v;;
end;;


;;

(* A map module from string keys to string values. *)
module StringStringMap = Treemap.Make(StringStringKV);;

(* Interface module for maps of int pairs to bool *)
module IntpairBoolKV = struct
  type key_t = int*int;;
  type value_t = bool;;
  let compare_keys (x1, x2) (y1, y2) =
    match x1 - y1 with
    | 0 -> x2 - y2
    | _ -> x1 - y1
  let keyval_string (x1, x2) b = sprintf "{%d > %d : %b}" x1 x2 b;;
end;;
;;

(* A map module from int pair keys to bool values. *)
module IntpairBoolMap = Treemap.Make(IntpairBoolKV);;
