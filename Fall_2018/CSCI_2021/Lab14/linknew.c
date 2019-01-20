#include <stdio.h>
int if_compute(int);
int i = 1; /* Answer 1a: weak, strong or neither? */
int j = 10;
int k = 5; /* Answer 1b: weak, strong or neither? */
 /* Answer 1c: Does it matter if k is weak or strong? */
static int a = 7; /* Answer 1d: weak, strong, or neither? */
int main() {
 static int x = 1; /* Answer 1e: weak, strong or neither? */
 int y; /* Answer 1f: weak, strong or neither? */
 printf("\nif_compute(i) is: %d", if_compute(i));
 printf("\nif_compute(j) is: %d", if_compute(j));
 printf("\nif_compute(k) is: %d", if_compute(k));
 printf("\nvalue of x is: %d", x);
 printf("\nThe value of a is: %d", a);
 printf("\n");
}
