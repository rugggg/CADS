//node.cuh
#ifndef NODE_CUH
#define NODE_CUH
#include <vector>
#include <cuda.h>

class Node
{
    private:
        std::vector<double>  m_weights;
        double m_x, m_y;
    
    public:
        Node(int x, int y, int numWeights);
        double calcDistance(const std::vector<double> &compareVector);
        std::vector<double> adjustWeights(const std::vector<double> &target,
                           const double lambda,
                           const double influence);
        void setWeights(const std::vector<double> &newWeights){m_weights = newWeights;}
        double X()const{return m_x;}
        double Y()const{return m_y;}

        //we're getting way too much white value here
        
        double getR(){return m_weights[0];}
        double getG(){return m_weights[1];}
        double getB(){return m_weights[2];}
};


#endif
