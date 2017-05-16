//node.cu

#include "node.cuh"
#include <stdlib.h>
#include <vector>
#include <time.h>
#include <math.h>
#include <cuda.h>
#include <thrust/device_vector.h>
#include "utils.h"

__global__ void cudaAdjustWeights(double *weight, double *target, const double lambda, const double influence){
    int i = (threadIdx.x + blockIdx.x * blockDim.x)-1;
    weight[i] += lambda* influence * (target[i] - weight[i]);
}


Node::Node(int x, int y, int numWeights){   
    for (int i = 0; i < numWeights; ++i){
        double r = RandFloat();
        m_weights.push_back(r);
        m_weightsCuda.push_back(r);
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

__host__ void Node::adjustWeights(const std::vector<double> &target, 
                         const double lambda, 
                         const double influence){
    for(int i=0; i < target.size(); ++i){
       m_weights[i] += lambda * influence * (target[i] - m_weights[i]);
    }
}

__host__ void Node::adjustWeightsCuda(thrust::host_vector<double> target, 
                         const double lambda, 
                         const double influence,
                         const int targetSize){
  
    thrust::device_vector<double> target_d = target;
    thrust::device_vector<double> weights_d = m_weightsCuda; 
    double *raw_weights = thrust::raw_pointer_cast(&weights_d[0]);
    double *raw_target = thrust::raw_pointer_cast(&target_d[0]);
    cudaAdjustWeights<<<3,1>>>(raw_weights, raw_target, lambda, influence);
    thrust::copy(weights_d.begin(), weights_d.end(), m_weightsCuda.begin());
    thrust::copy(weights_d.begin(), weights_d.end(), m_weights.begin());
}

