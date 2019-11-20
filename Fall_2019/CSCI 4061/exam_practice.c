#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char** argv) {
	// Problem 2
	// int i, pid;
	// for (i = 0; i < 3; i++){
	// 	pid = fork();
	//
	// 	if (pid > 0){
	// 		break;
	// 	}
	// }
	// printf("%d\n", i);

	// Problem 3
	fprintf(stdout, "Hello ");
	fprintf(stdout, "World ");
	fprintf(stderr, "This ");
	fprintf(stdout, "Here ");
	fprintf(stderr, "is an ");
	fprintf(stdout, "I come");
	fprintf(stderr, "error\n");
	fprintf(stdout, "\n");
}
