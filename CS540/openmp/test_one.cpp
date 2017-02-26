#include <omp.h>
#include <stdio.h>

int main()
{
    printf("Hello from main\n");
    #pragma omp parallel 
    {
        int myID = 0;
        printf("hello(%d)",myID);
        printf("world(%d)\n",myID);
        ++myID;
    }
}
        
