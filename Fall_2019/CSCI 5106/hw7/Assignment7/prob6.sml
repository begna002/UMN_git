(*PROBLEM 6*)
(*Problem 6.1/6.2: A signature BTree that matches with binary tree structures
 that provide a representation for binary trees AND a signature ITEM that
 encapsulates whatever is needed to be known about any data type to create a
 structure satisfying the BTree signature.*)

signature ITEM =
sig
  type item
  val lt : item * item -> bool
  val printVal : item -> unit
end;

signature BTree =
sig
  structure Item : ITEM
  type item = Item.item
  type 'a tree
  val initTree : item tree
  val insert : item * item tree -> item tree
  val member : item * item tree -> bool
  val printTree : item tree -> unit
end;

(*Problem 6.3: A functor BTree that takes a structure satisfying the ITEM
 signature and produces a structure satisfying the BTree signature.*)

functor BTree (Item : ITEM) : BTree =
struct
    structure Item = Item
    type item = Item.item

    fun lt(p:Item.item,q:Item.item) = Item.lt(p,q)
    fun printVal(p:Item.item) = Item.printVal(p)

    datatype 'a tree = Empty | Node of 'a * 'a tree * 'a tree

    val initTree = Empty

    fun insert(i, Empty) = Node(i, Empty, Empty)
      | insert(i, Tree as Node(j, ltree, rtree)) =
        if Item.lt(i,j) then Node(j, insert(i, ltree), rtree)
        else
         if Item.lt(j,i) then Node(j, ltree, insert(i, rtree))
         else Tree

    fun member(i, Empty) = false
      | member(i, Node(j, ltree, rtree)) =
        if Item.lt(i,j) then member(i, ltree)
        else
         if Item.lt(j,i) then member(i, rtree)
         else true


    fun printTree(Empty) = print("")
     | printTree(Node(j, ltree, rtree)) =
      (printTree(ltree);
      Item.printVal(j);
      printTree(rtree))

  end;

(*Problem 6.3: ITEM structures for integers and strings and use with the BTree
 functor *)

structure IntItem : ITEM =
struct
 type item = int
 val lt : (int * int ->bool) = op <;
 fun printVal x =  print(Int.toString(x)^ "\n");
end;

structure StringItem : ITEM =
struct
 type item = string
 val lt : (string * string ->bool) = op <;
 fun printVal x =  print(x^ "\n");
end;

structure IntTree = BTree(IntItem);
structure StrTree = BTree(StringItem);


Control.Print.printDepth := 100;
Control.Print.printLength := 100;

(*Problem 6.5 Creating and testing...*)
val intTree1 = IntTree.initTree;
val strTree1 = StrTree.initTree;

(*Test 1: Multiple insertions and print. The purpose of this test is to ensure
 that the insert function correctly inserts integer elements into an integer
 tree, while not inserting duplicates, and printing the result to test that the
 print function correctly uses an in-order traversal method of printing elements
*)

print("\nInteger Tree Test1: Multiple insertions and print\n");
print("\nInserting 9\n");
val intTree2 = IntTree.insert(9,intTree1);
print("\nInserting 21\n");
val intTree3 = IntTree.insert(21,intTree2);
print("\nInserting 4\n");
val intTree4 = IntTree.insert(4,intTree3);
print("\nInserting 11\n");
val intTree5 = IntTree.insert(11,intTree4);
print("\nInserting 4 again\n");
val intTree4 = IntTree.insert(4,intTree3);
print("\nPrinting Tree:\n");
IntTree.printTree(intTree5);

(*Test 2: 4 is a member. The purpose of this test is to ensure that the member
 function correctly returns true upon finding a queried item in a tree*)

print("\nInteger Tree Test2: 4 is a member?\n");
val test2 = IntTree.member(4,intTree5);

(*Test 3: 13 is not a member. The purpose of this test is to ensure that the
 member function correctly returns false upon not finding a queried item in a
 tree*)

print("\nInteger Tree Test3: 13 is a member?\n");
val test3 = IntTree.member(13,intTree5);

(*Test 4: Multiple insertions and print. The purpose of this test is to ensure
 that the insert function correctly inserts string elements into an string
 tree, while not inserting duplicates, and printing the result to test that the
 print function correctly uses an in-order traversal method of printing elements
*)

print("\nString Tree Test4: Multiple insertions and print\n");
print("\nInserting Golf\n");
val strTree2 = StrTree.insert("Golf",strTree1);
print("\nInserting November\n");
val strTree3 = StrTree.insert("November",strTree2);
print("\nInserting Alpha\n");
val strTree4 = StrTree.insert("Alpha",strTree3);
print("\nInserting Zulu\n");
val strTree5 = StrTree.insert("Zulu",strTree4);
print("\nPrinting Tree:\n");
StrTree.printTree(strTree5);

(*Test 5: Zulu is a member. The purpose of this test is to ensure that the
 member function correctly returns false upon not finding a queried item in a
 tree*)

print("\nInteger Tree Test2: Zulu is a member?\n");
val test2 = StrTree.member("Zulu",strTree5);

(*Test 6: Bravo is not a member. The purpose of this test is to ensure that the
 member function correctly returns false upon not finding a queried item in a
 tree*)

print("\nInteger Tree Test3: Bravo is a member?\n");
val test3 = StrTree.member("Bravo",strTree5);
