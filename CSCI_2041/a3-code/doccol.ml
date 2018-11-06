(* doccol.ml: Type and functions for a collection of named documents.
   Tracks a current document and its name along with an association
   list of all docs in the collection.  Preserves uniqueness of names
   in the collection. Makes use of built-in List functions to
   ad/remove/get docs from the association list. *)

(* Type to track a collection of named documents in an association
   list. *)
type 'a doccol = {
  mutable count   : int;                                  (* count of docs in list *)
  mutable curdoc  : 'a Document.document;                 (* current list being edited *)
  mutable curname : string;                               (* name of current list *)
  mutable docs    : (string * 'a Document.document) list; (* association list of names/docs *)
};;

let make name doc =
  let new_doccol = {count = 1; curdoc = doc; curname = name; docs = [(name, doc)]} in
  new_doccol;
;;
(* val make : string -> 'a Document.document -> 'a doccol
   Create a doccol. The parameters name and doc become the current
   doc and the only pair in the docs association list. *)

let add doccol name doc =
  match (List.mem_assoc name doccol.docs) with
  | true -> false
  | false ->
  doccol.count <- doccol.count + 1;
  doccol.docs <- (name, doc)::doccol.docs;
  true;
;;
(* val add : 'a doccol -> string -> 'a Document.document -> bool
   If there is already a doc with name in doccol, do nothing and
   return false.  Otherwise, add the given doc to doccol with the
   given name, update the count of docs and return true. Uses
   association list functions from the List module. *)

let remove doccol name =
  if doccol.curname = name then
    false
  else
    match (List.mem_assoc name doccol.docs) with
    | false -> false
    | true ->
    doccol.count <- doccol.count - 1;
    doccol.docs <- (List.remove_assoc name doccol.docs);
    true;
;;
(* val remove : 'a doccol -> string -> bool
   If name is equal to curname for the doccol, do nothing and return
   false.  If there is no doc with name in doccol, do nothing and
   return false.  Otherwise, remove the named doc from doccol,
   decrement the count of docs, and return true. Uses association list
   functions from the List module. *)

let has doccol name =
  match (List.mem_assoc name doccol.docs) with
  | true -> true
  | false -> false
;;
(* val has : 'a doccol -> string -> bool
   Returns true if the named doc is in the doccol and false otherwise. *)

let switch doccol name =
  match (List.mem_assoc name doccol.docs) with
  | false -> false
  | true ->
  doccol.curname <- name;
  doccol.curdoc <- (List.assoc name doccol.docs);
  true;;
;;
(* val switch : 'a doccol -> string -> bool
   Change the current document/name to the named document and return
   true. If the named document does not exist, return false and make
   no changes to doccol. *)

let string_of_doccol doccol =
  let split_assoc = List.split doccol.docs in
  let names = List.map (fun n -> "- "^n) (fst split_assoc) in
  ((string_of_int) doccol.count)^" docs"^"\n"^(String.concat "\n" (names))
;;

(* val string_of_col : 'a doccol -> string
   Creates a string representation of doccol showing the count of
   docs and the names of all docs. Each doc is listed on its own
   line. It has the following format:

   4 docs
   - test-dir/heros.txt
   - places.txt
   - stuff.txt
   - default.txt

   Does not define any helper functions. Makes use of higher order
   functions such as List.map and/or List.fold. May also use string
   processing functions such as String.concat and/or Printf.sprintf *)
