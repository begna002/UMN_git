#include <stdio.h>
//extern int proc1(int x, int y);
//extern int proc2(int x, int y);
extern int proc3(int x, int y);


int main() {
  int x = 3, y = 5;
  //printf("\nValue of %d + %d is %d\n", x, y, proc1(x, y));
  //printf("\nValue of %d * %d + %d * %d is %d\n", x, x, y, y, proc2(x, y));
  printf("\nLargest of %d and %d is %d\n", x, y, proc3(x, y));

}
