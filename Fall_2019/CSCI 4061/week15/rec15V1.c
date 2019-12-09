#include <stdio.h>
#include <signal.h>
#include <unistd.h>

int wait;
void sigintHandler(int sig_num)
{
    /* Reset handler to catch SIGINT next time.
       Refer http://en.cppreference.com/w/c/program/signal */
    signal(SIGINT, sigintHandler);
    printf("Signal raised %d\n", sig_num);
		if (wait == 1) {
    wait = 0;
  	} else {
			printf("Paused, waiting for SIGINT\n");
    wait = 1;
  	}
}

void foo() {

	static int count = 0;
	printf("%d: Count = %d\n", time(NULL), ++count);
}

int main() {

	/* Print infinitely. */
	signal(SIGINT, sigintHandler);

	while (1) {
		while(wait == 1) {
      sleep(1);
		}
		sleep(1);
		foo();
	}
}
