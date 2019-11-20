#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Solution to Problem 2, part 1: a single type that could be used for
representing integers or strings. */

typedef union{
 int num;
 char * str;
}StrorIntType;

/* Solution to Problem 2, part 2: a type that could be used for representing
either integer or string binary search trees. */
typedef enum {integer, string} kind;

struct node{
 StrorIntType elem;
 kind k;
 struct node *left, *right;
};

struct node *create(StrorIntType val, kind k) {
 struct node *new =  (struct node *)malloc(sizeof(struct node));
 new->elem = val;
 new->k = k;
 new->left = NULL;
 new->right = NULL;
 return new;
}

/* Solution to Problem 2, part 3: a function for determining if a given integer
or string appears in a given binary search tree*/

int isEqual(StrorIntType elem1, StrorIntType elem2, kind k) {
 if (k == 0) {
  if (elem1.num == elem2.num) {
   return 1;
  }
 }
 else if (k == 1) {
  if (strcmp(elem1.str, elem2.str) == 0) {
   return 1;
  }
 }
 return 0;

}

int compare(StrorIntType elem1, StrorIntType elem2, kind k) {
 if (k == 0) {
  return elem1.num - elem2.num;
 } else {
  return strcmp(elem1.str, elem2.str);
 }
}

int member(struct node* node, StrorIntType val,
 int (*eq)(StrorIntType, StrorIntType, kind),
 int (*ord)(StrorIntType, StrorIntType, kind)) {

  if (node == NULL ) {
   return 0;
  }
  if ((*eq)(node->elem, val, node->k) == 1) {
   return 1;
  }

  if ((*ord)(node->elem, val, node->k) < 0) {
   return member(node->right, val, isEqual, compare);
  }

  return member(node->left, val, isEqual, compare);
}

/* Solution to Problem 2, part 4: a function for inserting a given integer or
string into a given binary search tree */

struct node* insert(struct node* node, StrorIntType val,
 int (*ord)(StrorIntType, StrorIntType, kind), kind k) {
 if (node == NULL) {
  return create(val, k);
 }

 /* left Subtree is unchanged */
 if ((*ord)(node->elem, val, k) < 0) {
  node->right  = insert(node->right, val, compare, k);
 }
 /* Right Subtree is unchanged */
 else if ((*ord)(node->elem, val, k) > 0) {
  node->left = insert(node->left, val, compare, k);
 }

 return node;
}

/* Solution to Problem 1, part 5: a function to print elements in an integer
or string binary search tree using an inorder traversal*/

void printVal(StrorIntType val, kind k)  {
 if (k == 0) {
  printf("%d\n", val.num);
 } else {
  printf("%s\n", val.str);
 }
}

void printtree(struct node *node, void (*prt)(StrorIntType, kind k)) {
 if (node != NULL) {

  printtree(node->left, printVal);

  (*prt)(node->elem, node->k);

  printtree(node->right, printVal);
 }
}

void memberTest(int res) {
 if (res == 1) {
  printf("is a member of the tree\n");
 } else {
  printf("is not a member of the tree\n");
 }
}

int main() {
 struct node *tree = NULL;

 /* Test 1 For Integer tree */
 printf("Test 1: Integer tree\n");
 StrorIntType value;
 value.num = 10;
 struct node *intTree = insert(tree, value, compare, integer);
 value.num = 3;
 insert(intTree, value, compare, integer);
 value.num = 22;
 insert(intTree, value, compare, integer);
 value.num = 15;
 insert(intTree, value, compare, integer);
 value.num = 9;
 insert(intTree, value, compare, integer);
 printf("Tree:\n");
 printtree(intTree, printVal);

 value.num = 10;
 int res = member(intTree, value, isEqual, compare);
 printf("%d ", value.num);
 memberTest(res);

 value.num = 12;
 res = member(intTree, value, isEqual, compare);
 printf("%d ", value.num);
 memberTest(res);

 /* Test 2 For String tree */
 printf("\nTest 2: String tree\n");
 StrorIntType value2;
 value2.str = "ardvark";
 struct node *strTree = insert(tree, value2, compare, string);
 value2.str = "goose";
 insert(strTree, value2, compare, string);
 value2.str = "beetle";
 insert(strTree, value2, compare, string);
 value2.str = "zebra";
 insert(strTree, value2, compare, string);
 value2.str = "eagle";
 insert(strTree, value2, compare, string);
 printf("Tree:\n");
 printtree(strTree, printVal);

 value2.str = "ardvark";
 res = member(strTree, value2, isEqual, compare);
 printf("%s ", value2.str);
 memberTest(res);

 value2.str = "butterfly";
 res = member(strTree, value2, isEqual, compare);
 printf("%s ", value2.str);
 memberTest(res);

 return 0;
}
