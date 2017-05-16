#include "som.cuh"
#include "node.cuh"
#include "constants.h"
#include "utils.h"
#include <GL/glut.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/extrema.h>

__global__ void cudaEpochKernel(){
    
}

//calc distance from a given weight target to all vectors
__global__ void cudaGetDistance(double *targetVec, double *som, double *weights){
       //the som is 3x longer than the weights 
       //targetVec is fixed at length 3
       //let's say we allocate a thread for each weight entry
       int idx = (threadIdx.x + blockIdx.x * blockDim.x)-1;
        
       double dis = 0;
       for(int i =0; i < 3; ++i){
            dis += (targetVec[i] - som[idx+i]) * (targetVec[i] - som[idx+i]);
       }
       weights[idx] = sqrt(dis); 
}


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

__host__ bool Som::cudaEpoch(std::vector<std::vector <double> > data){
    if(data[0].size() != constSizeOfInputVector) return false;
    if(m_done) return true;
    if(--m_numIterations > 0){
        int curVector = RandInt(0, data.size()-1);
        double *data_raw = thrust::raw_pointer_cast(&data[curVector][0]);
        //we can find the best match by using cuda to calc all distances, and get min
        //flatten the som to be 1d ordered in chunks of 5[r,g,b,x,y]
         thrust::host_vector<double> flat_som;
         for (int r=0; r < m_som.size(); ++r){
            for (int c=0; c <m_som[r].size(); ++c){
              flat_som.push_back(m_som[r][c].getR());
              flat_som.push_back(m_som[r][c].getG());
              flat_som.push_back(m_som[r][c].getB());
              flat_som.push_back(m_som[r][c].X());
              flat_som.push_back(m_som[r][c].Y());
            }
         }
         std::cout<<"gate 1"<<std::endl;
         //allocate to device
         thrust::device_vector<double> som_d = flat_som;
         double *som_raw = thrust::raw_pointer_cast(&som_d[0]);

         std::cout<<"gate 2"<<std::endl;
         thrust::host_vector<double> distances(m_som.size()*m_som.size());
         thrust::device_vector<double> distances_d = distances;
         double *raw_distances = thrust::raw_pointer_cast(&som_d[0]);
         std::cout<<"gate 3"<<std::endl;
         cudaGetDistance<<<100,1>>>(data_raw, som_raw, raw_distances);
         thrust::copy(distances_d.begin(), distances_d.end(), distances.begin());

         std::cout<<"gate 4"<<std::endl;
         thrust::host_vector<double>::iterator iter = thrust::min_element(distances.begin(), distances.end());
         std::cout<<"gate 5"<<std::endl;
         unsigned int position = iter - distances.begin();
         std::cout<<"gate 6"<<std::endl;
         double min_val = *iter;
         m_neighborhoodRadius = m_mapRadius * exp(-(double)m_iterationCount/m_timeConstant);

        //lookup winner in m_som from position
         m_winningNode = &m_som[position/constNumCellsAcross][position%constNumCellsAcross];
         m_neighborhoodRadius = m_mapRadius * exp(-(double)m_iterationCount/m_timeConstant);

         std::cout<<"gate 4"<<std::endl;
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
                //m_som[i][n].adjustWeightsCuda(thrust::host_vector<double>(data[curVector]), m_lambda, m_influence,data[curVector].size());
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
                //m_som[i][n].adjustWeightsCuda(thrust::host_vector<double>(data[curVector]), m_lambda, m_influence,data[curVector].size());
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
