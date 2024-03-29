(* multimanager.ml : main function to allow manipulation of multiple
   lists of sorted, unique elements.  *)

open Printf;;
open Document;;
open Doccol;;
open Bulkops;;

(* Help string to be printed for the "help" command. *)
let help_string =
  let lines = [
      "MULTI MANAGER";
      "Maintains multiple sorted lists of unique elements..";
      "";
      "--PROGRAM COMMANDS--:";
      "  help           : print this help message";
      "  quit           : quit the program";
      "";
      "--CURRENT LIST COMMANDS--";
      "The following commands modify the current list";
      "  show           : print the current list to the screen";
      "  clear          : set the list to empty, preserves undo history";
      "  add <elem>     : add elem to the list";
      "  remove <elem>  : remove elem from list";
      "  mergein <file> : load the sorted list in the named file and merge with current list (undoable)";
      "  save           : save the current list using the name of the list as the save file";
      "  saveas <file>  : save the current list to the given file name; keeps the list name the same";
      "  undo           : undo the last operation restoring list to a previous state";
      "  redo           : redo the last undone operation restoring list to a previous state";
      "";
      "--LIST MANAGEMENT COMMANDS--";
      "The following commands will fail if a list name is already in use (new/open) or no present (close/edit/merge)";
      "  lists          : prints the lists that are currently open";
      "  edit <list>    : set the named list to the current list";
      "  new <list>     : create a new empty list and switch to it";
      "  open <file>    : create a new list named after the file specified; load the contents of the file into it and switch to it";
      "  close <list>   : close the list with given name and remove it from the open documents; cannot close the current list";
      "  merge <list>   : merge the named list contents into the current list";
      "";
      "--BULK OPERATIONS--";
      "The following commands act upon all open lists";
      "  showall        : print all lists labelled with their list name";
      "  saveall        : save all open lists; use filenames identical the list names (not undoable)";
      "  addall <elem>  : add elem to all open lists; each list can undo this individually";
      "  mergeall       : merge the contents of all lists into the current list; undoable";
    ] in
  String.concat "\n" lines
;;

(* Tracks the global state associated with the application. This
   binding uses a series of statements to initialize the global state
   to have a default empty list named 'default.txt' which is the
   current document and the only entry in the doccol. *)
let global : string list Doccol.doccol =
  let default_doc = Document.make [] in
  let default_name = "default.txt" in
  Doccol.make default_name default_doc
;;

(* Set to true to end execution of the program *)
let quit_now = ref false;;

(* val execute_command : string array -> unit
   Execute a single command which is the 0th element of the argument
   array tokens.  If the command has additional parameters these will
   be in tokens.(1), tokens.(2), etc.  Makes use of functions in Util,
   Sortedlist, Document, doccol, and Bulkops to implement each
   command. *)
let rec execute_command tokens =
  let cmd = tokens.(0) in       (* 0th element is command *)
  match cmd with
  (* ---PROGRAM COMMANDS-- *)
  | "help" ->
     printf "%s\n" help_string;
  | "quit" ->
     quit_now := true;

  (* --CURRENT LIST COMMANDS-- *)
  | "show" ->
     printf "--BEG LIST--\n";
     Sortedlist.print global.curdoc.current;
     printf "--END LIST--\n";
  | "clear" ->
     Document.set global.curdoc [];
  | "add" ->
     Document.set global.curdoc (Sortedlist.insert global.curdoc.current tokens.(1))
  | "remove" ->
     Document.set global.curdoc (Sortedlist.remove global.curdoc.current tokens.(1))
  | "save" ->
     Util.strlist_to_file global.curdoc.current global.curname
  | "saveas" ->
     Util.strlist_to_file global.curdoc.current tokens.(1)
  | "load" ->
     Document.set global.curdoc (Util.strlist_from_file tokens.(1))
  | "mergein" ->
     Document.set global.curdoc (Sortedlist.merge global.curdoc.current (Util.strlist_from_file tokens.(1)))
  | "undo" ->
     let test = Document.undo global.curdoc in
     if test = false then
        Printf.printf "\nWARNING: undo list empty, no changes made\n"
  | "redo" ->
     let test = Document.redo global.curdoc in
     if test = false then
      Printf.printf "WARNING: redo list empty, no changes made\n"

  (* --LIST MANAGEMENT COMMANDS-- *)
  | "lists" ->
    Printf.printf "%s\n" (Doccol.string_of_doccol global);
  | "edit" ->
     let test = (Doccol.switch global tokens.(1)) in
     if test = false then
      Printf.printf "ERROR: list '%s' does not exist\n" tokens.(1)
  | "new" ->
     let test = (Doccol.add global tokens.(1) (Document.make [])) in
     let test2 = (Doccol.switch global tokens.(1)) in
     global.curdoc.current <- [];
     if test = false then
      Printf.printf "WARNING: document name already exists";
     if test2 = false then
      Printf.printf "WARNING: document name doesn't exist";
  | "open" ->
     let test = (Doccol.add global tokens.(1) (Document.make [])) in
     if test = false then
        Printf.printf "ERROR: list '%s' already exists\n" tokens.(1)
     else
        let test2 = (Doccol.switch global tokens.(1)) in
        global.curdoc.current <- (Util.strlist_from_file tokens.(1));
        if test2 = false then
        Printf.printf "ERROR: list'%s' already exists\n" tokens.(1);
  | "close" ->
     let test2 = Doccol.has global tokens.(1) in
     if test2 = false then
      Printf.printf "ERROR: list '%s' does not exist\n" tokens.(1)
    else
      let test = Doccol.remove global tokens.(1) in
      if test = false then
        Printf.printf "ERROR: cannot close the current list\n";
  | "merge" ->
    Document.set global.curdoc (Sortedlist.merge global.curdoc.current ((List.assoc tokens.(1) global.docs).current))


  (* --BULK OPERATIONS-- *)
  | "showall" ->
     Bulkops.showall global
  | "saveall" ->
     Bulkops.saveall global
  | "addall" ->
     Bulkops.addall global tokens.(1)
  | "mergeall" ->
     Document.set global.curdoc (Bulkops.mergeall global)

  (* Catch-all *)
  | _ ->
     printf "Unknown command '%s'\n" tokens.(0)
;;

(*********************************************************************************
   Code beyond this point should not require modification though it
   may be interesting to examine.
*)
let echo  = ref false;;         (* command echoing on/off  *)
let debug = ref false;;         (* turn on/off debug printing *)

(* Options accepted by the program *)
let options = Arg.([
  ("-echo",  Set(echo),  "Turn on command echoing (default: off)");
  ("-debug", Set(debug), "Turn on debug printing  (default: off)");
]);;

(* Do nothing with extra command line arguments *)
let handle_extra_args arg = ();;

(* Simple usage message for Arg.parse *)
let usage = sprintf "usage: %s [options]" Sys.argv.(0);;

(* main routine *)
let _ =
  Arg.parse options handle_extra_args usage;    (* parse command line options *)
  begin try
      while !quit_now = false do                (* loop until quit command is issued *)
        printf "(%s)> " global.curname;         (* print prompt *)
        let line = read_line () in              (* read a line of input from stdin *)
        if !echo then                           (* if echoing is on, print the line *)
          printf "%s\n" line;
        let tokens =                            (* split line into tokens on spaces *)
          Array.of_list (Str.split (Str.regexp " +") line) in
        let ntok = Array.length tokens in
        if !debug then                          (* possibly print debuggin info on tokens *)
          begin
            printf "'%s' has %d tokens\n" line ntok;
            for i=0 to ntok-1 do
              printf "%d : %s\n" i tokens.(i);
            done
          end;
        if ntok>0 then
          try execute_command tokens;           (* execute a command *)
          with e ->                             (* out of bounds access, file not found, etc. doesn't kill program *)
            let excstring = Printexc.to_string e in
            printf "Error with '%s': %s\n" line excstring;
      done;
    with
    | End_of_file -> ()                         (* end of input reached *)
  end;
  printf "\nLists multi-managed!\n";
;;
