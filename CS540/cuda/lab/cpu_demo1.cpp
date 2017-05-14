#include <stdio.h>

  #define N (128*128)
  #define M (1000000)
  int main()
  {
     float data[N]; //declare an array of floats of size N
     int count = 0;

     for(int i = 0; i < N; i++)//index array
     {
        data[i] = 1.0f * i / N;
        for(int j = 0; j < M; j++)
        {
           data[i] = data[i] * data[i] - 0.25f;
        }
     }
     int input;
     
     printf("Enter an index: ");
     scanf("%d", &input);
     printf("data[%d] = %f\n", input, data[input]);
  }
