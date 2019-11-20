#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char** argv) {

	if (argc < 2) {

		printf("Incorrect number of args: given %d, expected 1.\n", argc - 1);
		exit(1);
	}

	pid_t pid = fork();
	wait(NULL);
	if (pid > 0) {
		pid_t pidTwo = fork();
		wait(NULL);
		if (pidTwo > 0) {
			exit(1);
		} else {
			execv("rtime.o", argv);
		  exit(1);
		}
	} else {
		execl("/bin/echo", "echo", "Hello World", (char*) NULL);
		exit(1);
	}

}
