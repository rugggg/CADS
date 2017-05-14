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


void Node::adjustWeights(const std::vector<double> &target, 
                         const double lambda, 
                         const double influence){

    //std::cout<<getR()<<" "<<getG()<<" "<<getB()<<std::endl;
    
    for(int i=0; i < target.size(); ++i){
      //  std::cout<<"adjust: l:"<<lambda<<"  i:"<<influence<<" ti: "<<target[i]<<" m:"<<m_weights[i]<<std::endl;
        m_weights[i] += lambda * influence * (target[i] - m_weights[i]);
      //  std::cout<<m_weights[i]<<std::endl;
    }
    //std::cout<<"ADJUSTING"<<std::endl;
    //std::cout<<getR()<<" "<<getG()<<" "<<getB()<<std::endl;
    //std::cout<<std::endl;
}

