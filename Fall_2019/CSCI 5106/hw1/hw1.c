#include<stdio.h>
#include<stdlib.h>

char * getOdds(char * lst, int len) {
 int newlen;
 if (len % 2 == 0) {
  newlen = len / 2;
 } else {
  newlen = (len / 2) + 1;
 }
 char *ret = malloc (sizeof (char) * newlen);
 int ind = 0;
 for (int i = 0; i < len; i+=2) {
  ret[ind] = lst[i];
  ind ++;
 }
 return ret;
}

void printArray(char * lst){
 for(int i = 0; i < sizeof(lst); i++) {
  printf("%c\n", lst[i]);
 }
}
// Odd Length
int test1() {
 char rep[] = {'a', 'b', '?', 'd', 'e'};
 char expect[] = {'a', '?', 'e'};
 char* result;
 result = getOdds(rep, sizeof(rep));
 int size = sizeof(rep);
 for (int i = 0; i < sizeof(expect); i++) {
  if (result[i] != expect[i]) {
   printf("Test 1 failed\n");
   return 0;
  }
 }
 printf("Test 1 passed\n");
 return 1;
}
// Even Length
int test2() {
 char rep[] = {'a', 'b', 'c', 'd'};
 char expect[] = {'a', 'c'};
 char* result;
 result = getOdds(rep, sizeof(rep));
 int size = sizeof(rep);
 for (int i = 0; i < sizeof(expect); i++) {
  if (result[i] != expect[i]) {
   printf("Test 2 failed\n");
   return 0;
  }
 }
 printf("Test 2 passed\n");
 return 1;
}
// Empty list
int test3() {
 char rep[] = {};
 char expect[] = {};
 char* result;
 result = getOdds(rep, sizeof(rep));
 int size = sizeof(rep);
 for (int i = 0; i < sizeof(expect); i++) {
  if (result[i] != expect[i]) {
   printf("Test 3 failed\n");
   return 0;
  }
 }
 printf("Test 3 passed\n");
 return 1;
}

int main(){
 int val1 = test1();
 int val2 = test2();
 int val3 = test3();
}
