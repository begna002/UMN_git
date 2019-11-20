#include <stdio.h>
#include <unistd.h>
int main(int argc, char *argv[]){
   int n = wait(NULL);
   printf("%d", n);
}
