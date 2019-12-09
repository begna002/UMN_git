#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void sigintHandler(int sig_num)
{
    /* Reset handler to catch SIGINT next time.
       Refer http://en.cppreference.com/w/c/program/signal */
    signal(SIGINT, sigintHandler);
    printf("\n Cannot be terminated with SIGINT \n");
    fflush(stdout);
}

void foo() {

	static int count = 0;
	printf("%d: Count = %d\n", time(NULL), ++count);
}

int main() {

	/* Print infinitely. */
	signal(SIGINT, sigintHandler);

	while (1) {
		sleep(1);
		foo();
	}
}
