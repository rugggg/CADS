/*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * NVIDIA Corporation and its licensors retain all intellectual property and 
 * proprietary rights in and to this software and related documentation. 
 * Any use, reproduction, disclosure, or distribution of this software 
 * and related documentation without an express license agreement from
 * NVIDIA Corporation is strictly prohibited.
 *
 * Please refer to the applicable NVIDIA end user license agreement (EULA) 
 * associated with this source code for terms and conditions that govern 
 * your use of this NVIDIA software.
 * 
 */


#include <thrust/host_vector.h>
#include <thrust/device_vector.h>


#define N   10

__global__ void add( int *a, int *b, int *c ) {
    int tid = blockIdx.x;    // this thread handles the data at its thread id
    if (tid < N)
        c[tid] = a[tid] + b[tid];
}

int main( void ) {
    // allocate the memory on the CPU
    thrust::host_vector<int> h_vec_a(N);
    thrust::host_vector<int> h_vec_b(N);
    thrust::host_vector<int> h_vec_c(N);
    // fill the arrays 'a' and 'b' on the CPU
    for (int i=0; i<N; i++) {
        h_vec_a[i] = -i;
        h_vec_b[i] = i * i;
    }

    // copy the arrays 'a' and 'b' to the GPU
    thrust::device_vector<int> d_vec_a = h_vec_a;
    thrust::device_vector<int> d_vec_b = h_vec_b;
    thrust::device_vector<int> d_vec_c(N);
    int *t_a = thrust::raw_pointer_cast(&d_vec_a[0]);
    int *t_b = thrust::raw_pointer_cast(&d_vec_b[0]);
    int *t_c = thrust::raw_pointer_cast(&d_vec_c[0]);
    //invoke add kernal with correct parameters
    add<<<N,1>>>(t_a, t_b, t_c); //because we use blockIdx.x, we should use 10 blocks, 1 thread each beacuse the operation is not parallelizable, and we need to hit all 10 indexesi

    thrust::copy(d_vec_c.begin(), d_vec_c.end(), h_vec_c.begin());

    // display the results
    for (int i=0; i<N; i++) {
        printf( "%d + %d = %d\n", h_vec_a[i], h_vec_b[i], h_vec_c[i] );
    }

    return 0;
}
