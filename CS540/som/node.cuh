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
        void adjustWeights(const std::vector<double> &target,
                           const double lambda,
                           const double influence);
        double X()const{return m_x;}
        double Y()const{return m_y;}

        //we're getting way too much white value here
        
        //int getR(){return (int)(((m_weights[0]-0)*(255-0))/(1-0))+0;}
        //int getG(){return (int)(((m_weights[1]-0)*(255-0))/(1-0))+0;}
        //int getB(){return (int)(((m_weights[2]-0)*(255-0))/(1-0))+0;}
            
        double getR(){return m_weights[0];}
        double getG(){return m_weights[1];}
        double getB(){return m_weights[2];}
};


#endif
