// cudaTrivial.cu

#include <cuda.h>
#include <iostream>

__global__ void cudaKernel(int* data) {
    //get thread id
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    //assign to data
    data[i] = i;
}

int main(int argc, char *argv[]){
    //set thread count based on args of blocks and threads
    //ideally would have some named params, but oh well
    int numThreads = 512;
    int numBlocks = 1;
    if(argc < 2){
        std::cout<<"No number of threads or blocks specified"<<std::endl;
    }
    else if(argc == 3){
        std::cout<<"Detected block and thread params..."<<std::endl; 
        numBlocks = std::atoi(argv[1]);
        numThreads = std::atoi(argv[2]);
    }
    else{
        std::cout<<"Detected only 1 arg, assuming it is thread count..."<<std::endl;
        numThreads = std::atoi(argv[1]);
    }
        std::cout<<"Using "<<numBlocks<<" blocks"<<std::endl;
        std::cout<<"Using "<<numThreads<<" threads"<<std::endl;
    int threadCount = numBlocks*numThreads;
    
    int data[threadCount];
    int* d_data;

    //allocate memory on device for int array of numThreads size
    cudaMalloc((void **) &d_data, threadCount*sizeof(int));
     
    //invoke kernel
    cudaKernel<<<numBlocks,numThreads>>>(d_data);

    //copy back from device to host
    cudaMemcpy(&data,d_data,threadCount*sizeof(int),cudaMemcpyDeviceToHost);
    
    //free mem
    cudaFree(d_data);
    for(int i = 0; i<threadCount; ++i){
        std::cout<<"Address "<<i<<" :: "<<data[i]<<std::endl;
    }
}




