fun oddOnly(lst) =
   if null(lst)
    then []
   else
    if null(tl lst)
     then hd(lst)::nil
    else
     hd(lst)::oddOnly(tl (tl lst));

fun test (actual, expected) =
 if (actual = expected)
  then print("Passed Test\n")
 else
  print("Failed Test\n");


val arr1 = "a"::"b"::"c"::"d"::"e"::nil;
val arr2 = "a"::"b"::"c"::"d"::nil;

val expected1 = "a"::"c"::"e"::nil;
val expected2 = "a"::"c"::nil;

val actual1 = oddOnly arr1;
val actual2 = oddOnly arr2;

test (actual1, expected1);
test (actual2, expected2);
