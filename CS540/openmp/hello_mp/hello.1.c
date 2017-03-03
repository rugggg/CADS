/* An OpneMP multithreaded program that prints hello world. 
   Compile with:
	cc -fopenmp file-name.c

*/

#include <omp.h>
#include <stdio.h>

int main()
{
	printf("Hello from main.\n");
	// Parallel region with default number of threads
    //the pragma omp parallel directive paralellizes the section following it
    //spawning a team of threads with the original thread as 0
    #pragma omp parallel
	{
		int myID = 0;
		printf("hello(%d)", myID);
		printf("world(%d)\n", myID);
	}
}
