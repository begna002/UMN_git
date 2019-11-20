#include <stdlib.h>
#include <stdio.h>

int i, j;

void swap(int x, int y) {
  i = y;
  j = x;
}

int main() {
  i = 2;
  j = 3;
  swap(i, j);
  printf("i = %d, j = %d\n", i, j);
  return 0;
}
