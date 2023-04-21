#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

int main() {
  int sequence[10] = {1,1,2,3,2,2,1,1,4,5};
  int n = 0;
  int count = 0;
  int trend = 0;

  while (n-- > 0) {
    int order = sequence[n] - sequence[n-1];

    if(order !=0) {
      bool turn = (trend != 0 ) && (trend > 0) != (order > 0);
      count += turn;
      trend = order;
    }
  }
  printf("Value: %d", count);

  return 0;
}
