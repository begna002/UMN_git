#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Solution to Problem 3, part 1: a type that is capable of representing binary
 search trees of arbitrary types of elements. */
typedef enum {integer, string, person} kind;

struct Person{
 char * first;
 char * last;
}Person;

struct node{
 void *elem;
 struct node *left, *right;
};

struct node *create(void *val) {
 struct node *new =  (struct node *)malloc(sizeof(struct node));
 new->elem = val;
 new->left = NULL;
 new->right = NULL;
 return new;
}

/* Solution to Problem 3, part 2: a function for determining if an arbitrary
value appears in a given binary search tree*/
int isEqual(void *elem1, void *elem2, kind k) {
 if (k == 0) {
  int val1 = *((int *) elem1);
  int val2 = *((int *) elem2);
  if (val1 == val2) {
   return 1;
  }
 }
 else if (k == 1) {
  char * str1 = (char*) elem1;
  char * str2 = (char*) elem2;
  if (strcmp(str1, str2) == 0) {
   return 1;
  }
 }
 else if (k == 2) {
  struct Person * str1 = elem1;
  struct Person * str2 = elem2;
  if (strcmp(str1->last, str2->last) == 0) {
   return 1;
  }
 }
 return 0;

}

int compare(void *elem1, void *elem2, kind k) {
 if (k == 0) {
  int val1 = *((int *) elem1);
  int val2 = *((int *) elem2);
  return val1 - val2;
 }
 else if (k == 1){
  char * str1 = (char*) elem1;
  char * str2 = (char*) elem2;
  return strcmp(str1, str2);
 }
 else if (k == 2){
  struct Person * str1 = elem1;
  struct Person * str2 = elem2;
  return strcmp(str1->last, str2->last);
 }
}

int member(struct node* node, void *val,
 int (*eq)(void*,void*, kind),
 int (*ord)(void*, void*, kind), kind k) {

  if (node == NULL ) {
   return 0;
  }

  if ((*eq)(node->elem, val, k) == 1) {
   return 1;
  }

  if ((*ord)(node->elem, val, k) < 0) {
   return member(node->right, val, isEqual, compare, k);
  }

  return member(node->left, val, isEqual, compare, k);
}

/* Solution to Problem 3, part 3: a function for inserting an arbitrary value
 into a given binary search tree */

 struct node* insert(struct node* node, void* val,
  int (*ord)(void*, void*, kind), kind k) {
  if (node == NULL) {
   return create(val);
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

 /* Solution to Problem 3, part 4: a function to print elements in an integer
 or string binary search tree using an inorder traversal*/

 void printVal(void *val, kind k)  {
  if (k == 0) {
   int num = *((int *) val);
   printf("%d\n", num);
  }
  else if (k == 1) {
   char * str1 = (char*) val;
   printf("%s\n", str1);
  }
  else if (k == 2) {
   struct Person * person = val;
   printf("%s %s\n", person->first, person->last);
  }
 }

 void printtree(struct node *node, void (*prt)(void*, kind k), kind k) {
  if (node != NULL) {

   printtree(node->left, printVal, k);

   (*prt)(node->elem, k);

   printtree(node->right, printVal, k);
  }
 }

 void memberTest(int res) {
  if (res == 1) {
   printf("is a member of the tree\n");
  } else {
   printf("is not a member of the tree\n");
  }
 }

int main(){
 struct node *tree = NULL;

 /* Test 1 For Integer tree */
 int num1 = 10;
 printf("Test 1: Integer tree\n");
 struct node *intTree = insert(tree, &num1, compare, integer);
 int num2 = 3;
 insert(intTree, &num2, compare, integer);
 int num3 = 22;
 insert(intTree, &num3, compare, integer);
 int num4 = 15;
 insert(intTree, &num4, compare, integer);
 int num5 = 9;
 insert(intTree, &num5, compare, integer);
 printf("Tree:\n");
 printtree(intTree, printVal, integer);

 int num = 10;
 int res = member(intTree, &num, isEqual, compare, integer);
 printf("%d ", num);
 memberTest(res);

 num = 12;
 res = member(intTree, &num, isEqual, compare, integer);
 printf("%d ", num);
 memberTest(res);

 /* Test 2 For String tree */
 printf("\nTest 2: String tree\n");
 char * str1 = "ardvark";
 struct node *strTree = insert(tree, str1, compare, string);
 char * str2 = "goose";
 insert(strTree, str2, compare, string);
 char * str3 = "beetle";
 insert(strTree, str3, compare, string);
 char * str4 = "zebra";
 insert(strTree, str4, compare, string);
 char * str5 = "eagle";
 insert(strTree, str5, compare, string);
 printf("Tree:\n");
 printtree(strTree, printVal, string);

 char* str6 = "ardvark";
 res = member(strTree, str6, isEqual, compare, string);
 printf("%s ", str6);
 memberTest(res);

 char* str7 = "butterfly";
 res = member(strTree, str7, isEqual, compare, string);
 printf("%s ", str7);
 memberTest(res);

 /* Test 3 For Person Struct tree */
 printf("\nTest 3: Person Struct tree\n");
 struct Person *per1 =  (struct Person *)malloc(sizeof(struct Person));
 per1->first = "Billy";
 per1->last = "Joel";
 struct node *perTree = insert(tree, per1, compare, person);

 struct Person *per2 =  (struct Person *)malloc(sizeof(struct Person));
 per2->first = "Michael";
 per2->last = "Jackson";
 insert(perTree, per2, compare, person);

 struct Person *per3 =  (struct Person *)malloc(sizeof(struct Person));
 per3->first = "Freddie";
 per3->last = "Mercury";
 insert(perTree, per3, compare, person);

 struct Person *per4 =  (struct Person *)malloc(sizeof(struct Person));
 per4->first = "Elton";
 per4->last = "John";
 insert(perTree, per4, compare, person);

 struct Person *per5 =  (struct Person *)malloc(sizeof(struct Person));
 per5->first = "Elvis";
 per5->last = "Presley";
 insert(perTree, per5, compare, person);
 printtree(perTree, printVal, person);

 struct Person *per6 =  (struct Person *)malloc(sizeof(struct Person));
 per6->first = "Elvis";
 per6->last = "Presley";
 res = member(perTree, per6, isEqual, compare, person);
 printf("%s %s ", per6->first, per6->last);
 memberTest(res);

 struct Person *per7 =  (struct Person *)malloc(sizeof(struct Person));
 per7->first = "Mick";
 per7->last = "Jagger";
 res = member(perTree, per7, isEqual, compare, person);
 printf("%s %s ", per7->first, per7->last);
 memberTest(res);

 return 0;
}
