//node.cu

#include "node.cuh"
#include <stdlib.h>
#include <vector>
#include <time.h>
#include <math.h>
#include <cuda.h>
#include "utils.h"

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


std::vector<double> Node::adjustWeights(const std::vector<double> &target, 
                         const double lambda, 
                         const double influence){
    for(int i=0; i < target.size(); ++i){
       //m_weights[i] += target[i] - m_weights[i];
       m_weights[i] += lambda * influence * (target[i] - m_weights[i]);
    }
    return m_weights;
}

