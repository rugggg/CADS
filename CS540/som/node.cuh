//node.cuh
#ifndef NODE_CUH
#define NODE_CUH
#include <vector>
#include <cuda.h>
#include <thrust/device_vector.h>

class Node
{
    private:
        std::vector<double>  m_weights;
        thrust::device_vector<double>  m_weightsCuda;
        double m_x, m_y;
    
    public:
        Node(int x, int y, int numWeights);
        double calcDistance(const std::vector<double> &compareVector);
        double calcDistanceCuda(thrust::device_vector<double> &compareVector);
        __host__ void adjustWeights(const std::vector<double> &target,
                           const double lambda,
                           const double influence);

        __host__ void adjustWeightsCuda(thrust::device_vector<double> target,
                           const double lambda,
                           const double influence,
                           const int targetSize);

        void setWeights(const std::vector<double> &newWeights){m_weights = newWeights;}
        double X()const{return m_x;}
        double Y()const{return m_y;}

        double getR(){return m_weights[0];}
        double getG(){return m_weights[1];}
        double getB(){return m_weights[2];}
};


#endif
