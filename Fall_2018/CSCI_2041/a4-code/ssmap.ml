(* ssmap.ml: Provides types and functions for a map from string keys
   to string values. Internally uses a binary search tree sorted on
   the keys. Some functions must be completed. *)

open Printf;;

(* Algebraic type for a persistent binary search tree key/value
   mappings.
*)
type ssmap =
  | Empty               (* no data: bottom of tree   *)
  | Node of {           (* node of anonymous record  *)
      key   : string;   (* key for this node         *)
      value : string;   (* value associated with key *)
      left  : ssmap;    (* left branch               *)
      right : ssmap;    (* right branch              *)
    }
;;

(* Empty map value. Could use Ssmap.Empty but it is standard libary
   convention to provide a binding called "empty" for this. *)
let empty = Empty;;

(* val add : ssmap -> string-> string -> ssmap

   let newmap = add map key value in ...

   Returns a new map with key bound to value. If key is already
   present, its binding is re-assigned to the given value.
*)
let rec add map key value =
  match map with
  | Empty ->                                             (* bottom of tree: didn't find *)
     Node{key=key; value=value;                          (* make a new node with key/val binding *)
          left=Empty; right=Empty}
  | Node(node) ->                                        (* at a node *)
     let diff = String.compare key node.key in           (* compute a difference *)
     if diff = 0 then                                    (* 0 indicates equal *)
       Node{node with value=value}                       (* replace value binding with new value *)
     else if diff < 0 then                               (* negative indicates str less than data *)
       Node{node with left=(add node.left key value)}    (* create a new node with new left branch *)
     else                                                (* positive indicates str greater than data *)
       Node{node with right=(add node.right key value)}  (* create new node with new right branch *)
;;

(* val tree_string : ssmap -> string

   let s = tree_string map in ...

   Use a Buffer (extensible string) and a right-to-left in-order
   traversal of the internal tree to construct a string version of the
   map. Nodes are indented according to their depth: root is left-most
   with children farther to the right. Each data element is preceded
   by its integer depth. Right-most elements appear at the top while
   left-most elements appear at the bottom. This means elements read
   in REVERSE order from top to bottom and that mentally rotating the
   tree clockwise gives appropriate left/right branch positions.
*)
let tree_string map =
  let buf = Buffer.create 256 in                    (* extensibel character buffer *)

  let rec build tree depth =                        (* recursive helper *)
    match tree with
    | Empty -> ()                                   (* out of tree, done with this branch *)
    | Node(node) ->                                 (* have a node *)
       build node.right (depth+1);                  (* recurse on right branch *)
       for i=1 to depth do                          (* indent according to depth of this node *)
         Buffer.add_string buf "  ";
       done;
       let datastr =                                (* string with depth and data  *)
         sprintf "%2d: {%s -> %s}\n" depth node.key node.value
       in
       Buffer.add_string buf datastr;               (* add to buffer *)
       build node.left (depth+1);                   (* recurse on left branch *)
  in                                                (* end helper *)

  build map 0;                                      (* recurse from root *)
  Buffer.contents buf                               (* return string from Buffer *)


(* IMPLEMENT

   val getopt : ssmap -> string -> string option

   let opt = getopt map key in ...

   Search the map for given key. If found, return the Some of the
   associated value. Otherwise return None.
*)
let rec getopt map key =
  match map with
  | Empty -> None
  | Node(node) ->
     let diff = String.compare key node.key in
     if diff = 0 then
       Some node.value
     else if diff < 0 then
       getopt node.left key
     else
       getopt node.right key
;;

(* IMPLEMENT

   val contains_key : ssmap -> string -> bool

   let present = contains_key map key in ...

   Returns true if key is present in the map and false
   otherwise. Uses function getopt.
*)
let contains_key map str =
  let opt = getopt map str in
  match opt with
  | None -> false
  | Some a -> true
;;


(* IMPLEMENT

   val iter : (string -> string -> unit) -> ssmap -> unit

   let func key value = ... in

   fold func map;

   Apply func to all elements key/value pairs in the map for
   side-effects. Keys are visited in sorted order from minimum to
   maximum. Works as other iter-like functions such as List.iter
   or Array.iter.
*)
let rec iter func map =
  match map with
  | Empty -> ()
  | Node(node)->
    iter func node.left;
    func node.key node.value;
    iter func node.right;
;;

(* IMPLEMENT

   val fold : ('a -> string -> string -> 'a) -> 'a -> ssmap -> 'a

   let func cur key value = ... in

   let reduction = fold func init map in ...

   Apply func to all elements key/value pairs in the map to produce a
   single value at the end. Keys are visited in sorted order from
   minimum to maximum. Works as other fold-like functions such as
   List.fold_left or Array.fold_left.
*)
let rec fold func cur map =
  match map with
  | Empty -> cur
  | Node(node)->
    let val1 = fold func cur node.left in
    let val2 = func val1 node.key node.value in
    let val3 = fold func val2 node.right in
    val3
;;


(* IMPLEMENT

   to_string : ssmap -> string

   let displaystr = to_string map in ...

   Produces a string representation of the map. The format is

   "[{k1 -> v1}, {k2 -> v2}, {k3 -> v4}]"

   Key/vals appear from minimum key to maximum key in the output
   string. Functionality from the Buffer module is used with an
   in-order traversal to produce the string efficiently. May make use
   of a higher-order map function such as iter or fold.
*)
let to_string map =
  match map with
  | Empty -> "[]"
  | _ ->
    let buf = Buffer.create 256 in
    Buffer.add_string buf "";
    let rec build tree =
      match tree with
      | Empty -> ()
      | Node(node) ->
         build node.left;
           Buffer.add_string buf "";
         let datastr =
           sprintf "{%s -> %s}, " node.key node.value
         in
         Buffer.add_string buf datastr;
         build node.right;
    in

    build map;
    let len = ((String.length (Buffer.contents buf)) - 2) in
    Buffer.truncate buf len;
    "["^(Buffer.contents buf)^"]"
;;

(* IMPLEMENT

   val findmin_keyval : ssmap -> (string * string)

   let (minkey,minval) = findmin ssmap in ...

   Find the "minimum" key in the given map and return it and its value
   as a pair. If used with an empty map, fails with exception message
   "No minimum in an empty tree".  Since the map is based on a BST,
   the minimum key is at the left-most node.
*)
let rec findmin_keyval map =
  match map with
  | Empty -> failwith "No minimum in an empty tree"
  | Node(node) ->
    if node.left = Empty then
      (node.key, node.value)
    else
      findmin_keyval node.left
;;

(* IMPLEMENT

   val remove_key : ssmap -> string -> ssmap

   let newmap = remove map key in ...

   Returns a new map without key in it.  The internal tree is
   re-arranged according to standard BST conventions: (1) If key is a
   leaf, it is replaced with Empty, (2) If key is an internal node
   with one child, it's left or right branch replaces it, (3) If key
   is an internal node with both left/right children, it successor
   replaces it. Makes use of findmin_keyval to locate a succesor as
   the minimum of on the right child branch.
*)
let rec remove_key map key =
match map with
| Empty -> Empty
| Node(node) ->
   let diff = String.compare key node.key in
   if diff = 0 then
     match node.left, node.right with
     | Empty, Empty -> Empty
     | _ , Empty -> node.left
     | Empty, _ -> node.right
     | _ , _ ->
        let (succ_key, succ_val) = findmin_keyval node.right in
        Node{key = succ_key; value = succ_val; left = node.left; right = remove_key node.right succ_key}
        (*(remove_key node.right succ_key)*)
   else if diff < 0 then
     Node{node with left=(remove_key node.left key)}
   else
     Node{node with right=(remove_key node.right key)}
;;
