#include <stdio.h>

#define N (1024*1024)
#define M (1000000)

  __global__ void cudakernel(float *buf)
  {
     /* 
        this line is looking up the address i by taking the thread id (threadIdx.x)
        adding to block id (blockIdx.x), which is multiplied by the block dimensions
        This means that each thread coming into this has a unique ID, then by the line 
        below, the thread is assigned to work on a certain section of the data block
    */
     int i = threadIdx.x + blockIdx.x * blockDim.x; //what is this line doing?  
     buf[i] = 1.0f * i / N;
     for(int j = 0; j < M; j++)
        buf[i] = buf[i] * buf[i] - 0.25f;
  }

  int main()
  {
     float data[N];
     float *d_data; //device pointer

     //allocate memory on GPU
     cudaMalloc((void**) &d_data, N*sizeof(float));  
     //invoke kernel with 4096 blocks of 256 threads
     cudakernel<<<4096, 256>>>(d_data); 
     //copy results back to host
     cudaMemcpy(data, d_data, N*sizeof(float), cudaMemcpyDeviceToHost);
     cudaFree(d_data); 

     int input;
     printf("Enter an index: ");
     scanf("%d", &input);
     printf("data[%d] = %f\n", input, data[input]);
  }
