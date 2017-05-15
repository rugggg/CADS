//node.cu

#include "node.cuh"
#include <stdlib.h>
#include <vector>
#include <time.h>
#include <math.h>
#include <cuda.h>
#include <thrust/device_vector.h>
#include "utils.h"

__global__ void cudaAdjustWeights(double *weight, double *target, double lambda, double influence){
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    weight[i] += lambda * influence * (target[i] - weight[i]);
}

Node::Node(int x, int y, int numWeights){   
    for (int i = 0; i < numWeights; ++i){
        m_weights.push_back(RandFloat());
    }
    m_x = x;
    m_y = y;
}

double Node::calcDistance(const std::vector<double> &compareVector){
    double dis = 0;
    for(int i =0; i < m_weights.size(); ++i){
        dis += (compareVector[i] - m_weights[i]) * (compareVector[i] - m_weights[i]);
    }
    return sqrt(dis);
}


__host__ double calcDistanceCuda(thrust::device_vector<double> &compareVector){
    double dis = 0;
    for(int i =0; i < 3; ++i){
        dis += (compareVector[i] - m_weights[i]) * (compareVector[i] - m_weights[i]);
    }
    return sqrt(dis);   
}

__host__ void Node::adjustWeights(const std::vector<double> &target, 
                         const double lambda, 
                         const double influence){
    for(int i=0; i < target.size(); ++i){
       m_weights[i] += lambda * influence * (target[i] - m_weights[i]);
    }
}

__host__ void Node::adjustWeightsCuda(thrust::device_vector<double> target, 
                         const double lambda, 
                         const double influence,
                         const int targetSize){
    
    double *raw_weights = thrust::raw_pointer_cast(&m_weightsCuda[0]);
    double *raw_target = thrust::raw_pointer_cast(&target[0]);
    cudaAdjustWeights<<<1,1>>>(raw_weights, raw_target, lambda, influence);
    thrust::copy(m_weightsCuda.begin(), m_weightsCuda.end(), m_weights.begin());
}

