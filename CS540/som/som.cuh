#ifndef SOM_H
#define SOM_H

#include <vector>
#include "node.cuh"
#include "constants.h"
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

class Som{
    private:
        std::vector<std::vector<Node> > m_som;
        Node* m_winningNode;
        double m_mapRadius; 
        double m_timeConstant;
        double m_neighborhoodRadius;
        double m_influence;
        double m_lambda;
        int m_numIterations;
        int m_iterationCount;
        bool m_done;

        __host__ Node* findBestMatch(const std::vector<double> &vec);
        __device__ Node* findBestMatchCuda(double *vec, int weightSize);
        __host__ double Gaussian(const double dist, const double sigma);

    public:
        Som(): m_winningNode(NULL),
               m_iterationCount(1),
               m_numIterations(0),
               m_timeConstant(0),
               m_mapRadius(0),
               m_neighborhoodRadius(0),
               m_influence(0),
               m_lambda(constStartLearningRate),
               m_done(false)
        {};

        void create(int cellsUp,
                    int cellsAcross,
                    int numIterations);

        void render();
        void print();
        void flipDone();
        int getIteration(){return m_iterationCount;}
        __host__ bool epoch(const std::vector<std::vector<double> > &data);
        __host__ bool cudaEpoch(std::vector<std::vector<double> > data);
        __host__ bool finishedTraining()const{return m_done;}
};

        


#endif
