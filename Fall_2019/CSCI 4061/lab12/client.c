#define _BSD_SOURCE
#define NUM_ARGS 0

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <pthread.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

#define SERVER_PORT 4061
char buff[1024];

int main(int argc, char** argv) {

		if (argc < NUM_ARGS + 1) {

			printf("Wrong number of args, expected %d, given %d\n", NUM_ARGS, argc - 1);
			exit(1);
		}

		// Create a TCP socket.
		int sockfd = socket(AF_INET , SOCK_STREAM , 0);

		// Specify an address to connect to (we use the local host or 'loop-back' address).
		struct sockaddr_in address;
		address.sin_family = AF_INET;
		address.sin_port = htons(SERVER_PORT);
		address.sin_addr.s_addr = inet_addr("127.0.0.1");

		// Connect it.
		if (connect(sockfd, (struct sockaddr *) &address, sizeof(address)) == 0) {

		//TODO: take input from user
		char * input = argv[1];


		//TODO: send the data to server
		write(sockfd, input, sizeof(input));


		//TODO: read data from server and print
		read(sockfd, buff, sizeof(buff));
		printf("%s\n", buff);





		//close connection
		close(sockfd);

	} else {

		perror("Connection failed!");
	}
}
