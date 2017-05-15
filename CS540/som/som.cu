#include "som.cuh"
#include "node.cuh"
#include "constants.h"
#include "utils.h"
#include <GL/glut.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

void Som::create(int cellsUp,
                 int cellsAcross,
                 int numIterations)
{
    m_numIterations = numIterations;

    for(int row=0; row<cellsUp; ++row){
        std::vector<Node> m_row;
        for(int col=0; col<cellsAcross; ++col){
            m_row.push_back(Node(row,col,constSizeOfInputVector));
        }
        m_som.push_back(m_row);
    }
    m_mapRadius = max(constWindowWidth, constWindowHeight);
    m_timeConstant = m_numIterations/log(m_mapRadius);
    std::cout<<"tc: "<<m_timeConstant<<"  mr: "<<m_mapRadius<<std::endl;
}

__host__ bool Som::epoch(const std::vector<std::vector<double> > &data){
    if(data[0].size() != constSizeOfInputVector) return false;
    if(m_done) return true;
    if(--m_numIterations > 0){
        int curVector = RandInt(0, data.size()-1);
        m_winningNode = findBestMatch(data[curVector]);
        m_neighborhoodRadius = m_mapRadius * exp(-(double)m_iterationCount/m_timeConstant);

        for(int i=0; i<m_som.size(); ++i){
            for(int n=0; n<m_som[i].size(); ++n){
            double distToNodeSq = (m_winningNode->X()-m_som[i][n].X())*
                                (m_winningNode->X()-m_som[i][n].X())+
                                (m_winningNode->Y()-m_som[i][n].Y())*
                                (m_winningNode->Y()-m_som[i][n].Y());

            double widthSq = m_neighborhoodRadius * m_neighborhoodRadius;
            if(distToNodeSq < (widthSq)){
                m_influence = exp(-(distToNodeSq)/(2*widthSq));
                
                m_som[i][n].adjustWeights(data[curVector], m_lambda, m_influence);
            }
        }
        }
        m_lambda = constStartLearningRate * exp(-(double)m_iterationCount/m_numIterations);
        ++m_iterationCount;
    }
    else{
        m_done = true;
    } 
    return true;
}

__device__ bool Som::cudaEpoch(const thrust::device_vector<thrust::device_vector<double> > &data, int dataSize){
    if(dataSize != constSizeOfInputVector) return false;
    if(m_done) return true;
    if(--m_numIterations > 0){
        int curVector = RandInt(0, data.size()-1);
        //std::cout<<"Current Vector:: "<<std::endl;
        //std::cout<<data[curVector][0]<<" "<<data[curVector][1]<<" "<<data[curVector][2]<<std::endl;
        m_winningNode = findBestMatchCuda(data[curVector]);
        m_neighborhoodRadius = m_mapRadius * exp(-(double)m_iterationCount/m_timeConstant);

        for(int i=0; i<m_som.size(); ++i){
            for(int n=0; n<m_som[i].size(); ++n){
            double distToNodeSq = (m_winningNode->X()-m_som[i][n].X())*
                                (m_winningNode->X()-m_som[i][n].X())+
                                (m_winningNode->Y()-m_som[i][n].Y())*
                                (m_winningNode->Y()-m_som[i][n].Y());

            double widthSq = m_neighborhoodRadius * m_neighborhoodRadius;
            if(distToNodeSq < (widthSq)){
                m_influence = exp(-(distToNodeSq)/(2*widthSq));
                m_som[i][n].adjustWeightsCuda(data[curVector], m_lambda, m_influence, dataSize);
            }
        }
        }
        m_lambda = constStartLearningRate * exp(-(double)m_iterationCount/m_numIterations);
        ++m_iterationCount;
    }
    else{
        m_done = true;
    } 
    return true; 
}

__host__ Node* Som::findBestMatch(const std::vector<double> &vec){
    Node* winner = NULL;
    double lowestDistance = 999999;
    for(int i=0; i<m_som.size(); ++i){
        for(int n=0; n<m_som[i].size(); ++n){
            double dist = m_som[i][n].calcDistance(vec);
            if(dist < lowestDistance){
                lowestDistance = dist;
                winner = &m_som[i][n];
            }
        }
    }
    return winner;
}

__device__ Node* Som::findBestMatchCuda(const thrust::device_vector<double> &vec){
    Node* winner = NULL;
    double lowestDistance = 999999;
    for(int i=0; i<m_som.size(); ++i){
        for(int n=0; n<m_som[i].size(); ++n){
            double dist = m_som[i][n].calcDistanceCuda(vec);
            if(dist < lowestDistance){
                lowestDistance = dist;
                winner = &m_som[i][n];
            }
        }
    }
    return winner;
}


void Som::render(){
//    print();
    
    for (int j=0; j<m_som.size(); ++j){
        for (int i=0; i<m_som[j].size(); ++i){
            glColor3f(m_som[j][i].getR(), m_som[j][i].getG(), m_som[j][i].getB());
            glBegin(GL_QUADS);
            glVertex3f(j, i, 0);            // upper left
            glVertex3f(j, i-1, 0);            // lower left
            glVertex3f(j+1, i-1, 0);            // upper right
            glVertex3f(j+1, i, 0);            // lower right
            glEnd();
        }
    }
}    

void Som::print(){
    std::cout<<std::endl;
    std::cout<<std::endl;
    std::cout<<"==================================================="<<std::endl;
    std::cout<<std::endl;
    for (int j=0; j<m_som.size(); ++j){
        std::vector<Node> row = m_som[j];
        for (int i=0; i<row.size(); ++i){
            std::cout<<"[ "<<row[i].getR()<<", "<<row[i].getG()<<", "<<row[i].getB()<<" ]    ";
        }
        std::cout<<std::endl;
    }
}

void Som::flipDone(){
    m_done = !m_done;
    if(m_done)
        std::cout<<"Stopped Training"<<std::endl;
    else
        std::cout<<"Training..."<<std::endl;
}
