#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

int twists(int sequence[], int n) {
  int count = 0;
  int trend = 0;

  while (n-- > 0) {
    printf("n: %d\n", n);
    int order = sequence[n] - sequence[n-1];
    printf("order: %d\n", order);
    printf("sequence[n-1: %d\n", sequence[n-1]);

    if(order !=0) {
      bool turn = (trend != 0 ) && (trend > 0) != (order > 0);
      count += turn;
      trend = order;
    }
  }
  return count;
}


int main() {
  // int seq[] = {1,1,2,3,2,2,1,1,4,5};
  int seq[] = {-1, 0, 1};

  size_t size = sizeof(seq)/sizeof(seq[0]);

  int ret = twists(seq, size);
  printf("Value: %d", ret);

  return 0;
}
