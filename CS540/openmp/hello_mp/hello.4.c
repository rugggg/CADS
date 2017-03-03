/* An OpneMP  multithreaded program where each thread prints hello world. 
   Compile with an appropriate switch:
     cc -fopenmp file-name.c
*/

#include <omp.h>
#include <stdio.h>

int main()
{
	printf("Hello from main.\n");
	// Parallel region with a non-default number of threads:	
	#pragma omp parallel num_threads(20)
	{
		// Runtime library function to return a thread ID:
		int myID = omp_get_thread_num();
		printf("hello(%d)", myID);
		printf("world(%d)\n", myID);
	}
}
