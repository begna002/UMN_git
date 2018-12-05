/* linknewif.c */
#include <stdio.h>

//int k = 5;
float k = 3.14; /* Answer 1g: weak, strong or neither? */
static int i = 456; /* Answer 1h: weak, strong or neither? */
int if_compute(int x) { /* Answer 1i: weak, strong or neither? */
 int result;
 if (x > 1)
 result = x;
 else result = -100;
 return result;
}
