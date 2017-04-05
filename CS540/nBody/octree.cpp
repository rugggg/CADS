//octree.cpp

#include "octree.hpp"
#include <iostream>
#include <algorithm>
#include <random>
#include <math.h>
#include <omp.h>
#include <sys/time.h>
#include <ctime>


Octree::Octree(NodePoint center, const double size, std::list<NodePoint> points){
    instance_count++;
    id = instance_count;
    m_center = center;
    m_size = size;
    m_points = points;
    m_depth = 0;
    setBounds();
}

Octree::Octree(NodePoint center, const double size, Octree *parent, std::list<NodePoint> points){
    instance_count++;
    id = instance_count;
    m_center = center;
    m_size = size;   
    //maxDepth = parent->getDepth()+1; 
    m_depth = parent->getDepth()+1;
    m_parent = parent;
    setBounds();
}

Octree::~Octree(){}

int Octree::instance_count = 0;

void Octree::setBounds(){
    //use our size and center to compute and store boundaries
    double distance = cbrt(m_size)/2;
    m_nodeBounds.xBound.upper = m_center.x + distance;
    m_nodeBounds.xBound.lower = m_center.x - distance;
    m_nodeBounds.yBound.upper = m_center.y + distance;
    m_nodeBounds.yBound.lower = m_center.y - distance;
    m_nodeBounds.zBound.upper = m_center.z + distance;
    m_nodeBounds.zBound.lower = m_center.z - distance;
}

double Octree::getSize(){
    return m_size;
}

NodePoint Octree::getCenter(){
    return m_center;
}

int Octree::getDepth(){
    return m_depth;
}

NodeBounds Octree::getBounds(){
    return m_nodeBounds;
}

std::list<NodePoint> Octree::getPoints(){
    return m_points;
}

void Octree::insertPoint(NodePoint np){
    if((std::find(m_points.begin(), m_points.end(), np) == m_points.end())){
        m_points.push_back(np);
    }
}
void Octree::printBounds(){
    NodeBounds nb = this->getBounds();
    printSpaces();
    std::cout<<nb.xBound.upper<<":"<<nb.xBound.lower<<std::endl;
    printSpaces();
    std::cout<<nb.yBound.upper<<":"<<nb.yBound.lower<<std::endl;
    printSpaces();
    std::cout<<nb.zBound.upper<<":"<<nb.zBound.lower<<std::endl;
}

bool Octree::inBounds(NodePoint pointToCheck){
    if((pointToCheck.x <= m_nodeBounds.xBound.upper && pointToCheck.x >= m_nodeBounds.xBound.lower) &&
      (pointToCheck.y <= m_nodeBounds.yBound.upper && pointToCheck.y >= m_nodeBounds.yBound.lower) &&
      (pointToCheck.z <= m_nodeBounds.zBound.upper && pointToCheck.z >= m_nodeBounds.zBound.lower)){
        return true;
    }
    else{
        return false;
    }
}

void Octree::split(std::list<NodePoint> points){
    //check if we have less than the minimum number of points in us
    //also check if we are past max depth
    //if either of those are true we are a leaf
    if(m_depth >= maxDepth || points.size() <= 1){
    //if(points.size() <= 1){
        std::list<NodePoint>::const_iterator node_it = points.begin();
        while (node_it != points.end()){
            insertPoint(*node_it);
            node_it = m_points.erase(node_it);
        }
        return;
    }
    else{
        //else: we take split into a child octree and pass the points forward
        //into that tree and place the current octree into the new children
        //to split we should start from one corner of the cube, so the lower x,y,z
        //the size is 1/8 the last size
        double childSize = m_size/8;
        //we now have the size, now we need the eight centers
        double childDistance = cbrt(childSize)/2;
        NodePoint fur_childCenter,ful_childCenter,
                  fdr_childCenter,fdl_childCenter,
                  bur_childCenter,bul_childCenter,
                  bdr_childCenter,bdl_childCenter;
        
        #pragma omp parallel
        {
        #pragma omp single nowait
        {
        #pragma omp task shared(fur_childCenter)
        {
        fur_childCenter.x = m_center.x+childDistance;
        fur_childCenter.y = m_center.y+childDistance;
        fur_childCenter.z = m_center.z+childDistance;
//        Octree fur = Octree(fur_childCenter,childSize,this,m_points);
//        m_children.push_back(fur);
        }
        #pragma omp task shared(ful_childCenter)
        {   
        ful_childCenter.x = m_center.x-childDistance;
        ful_childCenter.y = m_center.y+childDistance;
        ful_childCenter.z = m_center.z+childDistance;
//        Octree ful = Octree(ful_childCenter,childSize,this,m_points);
//        m_children.push_back(ful);
        }
        #pragma omp task shared(fdr_childCenter)
        {
        fdr_childCenter.x = m_center.x+childDistance;
        fdr_childCenter.y = m_center.y-childDistance;
        fdr_childCenter.z = m_center.z+childDistance;
//        Octree fdr = Octree(fdr_childCenter,childSize,this,m_points);
//        m_children.push_back(fdr);
        }
        #pragma omp task shared(fdl_childCenter)
        {
        fdl_childCenter.x = m_center.x-childDistance;
        fdl_childCenter.y = m_center.y-childDistance;
        fdl_childCenter.z = m_center.z+childDistance;
//        Octree fdl = Octree(fdl_childCenter,childSize,this,m_points);
//        m_children.push_back(fdl);
        }
        #pragma omp task shared(bur_childCenter)
        {
        bur_childCenter.x = m_center.x+childDistance;
        bur_childCenter.y = m_center.y+childDistance;
        bur_childCenter.z = m_center.z-childDistance;
//        Octree bur = Octree(bur_childCenter,childSize,this,m_points);
//        m_children.push_back(bur);
        }
        #pragma omp task shared(bul_childCenter)
        {
        bul_childCenter.x = m_center.x-childDistance;
        bul_childCenter.y = m_center.y+childDistance;
        bul_childCenter.z = m_center.z-childDistance;
//        Octree bul = Octree(bul_childCenter,childSize,this,m_points);
//        m_children.push_back(bul);
        }
        #pragma omp task shared(bdr_childCenter)
        {
        bdr_childCenter.x = m_center.x+childDistance;
        bdr_childCenter.y = m_center.y-childDistance;
        bdr_childCenter.z = m_center.z-childDistance;
//        Octree bdr = Octree(bdr_childCenter,childSize,this,m_points);
//        m_children.push_back(bdr);
        }
        #pragma omp task shared(bdl_childCenter)
        {
        bdl_childCenter.x = m_center.x-childDistance;
        bdl_childCenter.y = m_center.y-childDistance;
        bdl_childCenter.z = m_center.z-childDistance;
//        Octree bdl = Octree(bdl_childCenter,childSize,this,m_points);
//        m_children.push_back(bdl);
        }
        #pragma omp taskwait
        }
        }

        Octree fur = Octree(fur_childCenter,childSize,this,m_points);
        Octree ful = Octree(ful_childCenter,childSize,this,m_points);
        Octree fdr = Octree(fdr_childCenter,childSize,this,m_points);
        Octree fdl = Octree(fdl_childCenter,childSize,this,m_points);
        Octree bur = Octree(bur_childCenter,childSize,this,m_points);
        Octree bul = Octree(bul_childCenter,childSize,this,m_points);
        Octree bdr = Octree(bdr_childCenter,childSize,this,m_points);
        Octree bdl = Octree(bdl_childCenter,childSize,this,m_points);

        m_children.push_back(fur);
        m_children.push_back(ful);
        m_children.push_back(fdr);
        m_children.push_back(fdl);
        m_children.push_back(bur);
        m_children.push_back(bul);
        m_children.push_back(bdr);
        m_children.push_back(bdl);

        // now start at from the beginning
        // and keep iterating over the element till you find
        // nth element...or reach the end of vector.
        std::vector<Octree>::iterator it;
        for(it=m_children.begin() ; it < m_children.end(); it++) {
            std::list<NodePoint>::const_iterator node_it = m_points.begin();
            while (node_it != m_points.end()){
                if(it->inBounds(*node_it)) {
                    it->insertPoint(*node_it);
                    node_it = m_points.erase(node_it);
                }
                else{
                    node_it++;
                }
            }
         }
         if(m_points.size() != 0){
             std::cout<<m_points.size()<<std::endl;
             std::cout<<m_points.back().x<<std::endl;
             std::cout<<m_points.back().y<<std::endl;
             std::cout<<m_points.back().z<<std::endl;
             std::vector<Octree>::iterator it; 
             std::cout<<" BAIL "<<std::endl;
             exit(0);
         }
            for(it=m_children.begin() ; it < m_children.end(); it++) {
                it->split(it->m_points);
            }
            
    }
}

void Octree::traverse(){
    //starting from the initial node
    //print self, then children
    //for each child, traversee them
    printSpaces();
    std::cout<<"Node Id: "<<id<<std::endl;
    printSpaces();
    std::cout<<"Node Center: ";
    printSpaces();
    std::cout<<"  "<<m_center.x<<","<<m_center.y<<","<<m_center.z<<std::endl;
    printSpaces();
    std::cout<<"Node Size: "<<m_size<<std::endl;
    printSpaces();
    std::cout<<"Node Bounds: "<<std::endl;
    printBounds();
    printSpaces();
    std::cout<<"Node Points: "<<m_points.size()<<std::endl;
    {
    for (std::list<NodePoint>::const_iterator it = m_points.begin(), end = m_points.end(); it != end; ++it) {
        printSpaces();
        std::cout<<"Point: "<<std::endl;
        printSpaces();
        std::cout<<"  "<<it->x<<","<<it->y<<","<<it->z<<std::endl;
    }}
    {
    for (std::vector<Octree>::iterator it=m_children.begin(); it < m_children.end(); ++it){
        it->traverse();
    }
    }
    std::cout<<std::endl;
}

void Octree::printSpaces(){
    for(int i = 0;i < m_depth;++i){
        std::cout<<"  ";
    }
}

int Octree::maxDepth = 7;

double fRand(double fMin, double fMax)
{
    double f = (double)rand() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

void Process(Octree* o){
    int temp_id = o->id;
//    std::cout<<o->id<<std::endl;
}
void octree_traverse_p(Octree *o){  
    for (std::vector<Octree>::iterator it=o->m_children.begin(); it < o->m_children.end(); ++it){
                #pragma omp task
                octree_traverse_p(&(*it));
    }
    Process(o);

}
void octree_traverse(Octree *o){  
    for (std::vector<Octree>::iterator it=o->m_children.begin(); it < o->m_children.end(); ++it){
                octree_traverse(&(*it));
    }
    Process(o);

}

int main(){
    double sim_size = 1000000; 
    int numPoints   = 100000;

    double max_bound = cbrt(sim_size)/2;   
    NodePoint center;
    center.x = 0;
    center.y = 0;
    center.z = 0;
    
    std::list<NodePoint> initialPoints;
    srand (time(NULL));

    for(int i; i<numPoints; ++i){
        NodePoint np;
        np.x = fRand(-max_bound,max_bound); 
        np.y = fRand(-max_bound,max_bound); 
        np.z = fRand(-max_bound,max_bound); 
        initialPoints.push_back(np);
    }

    Octree init_octree = Octree(center,sim_size,initialPoints);
    init_octree.split(initialPoints);
    //init_octree.traverse();
    //
    std::cout<<"octree nodes:"<<Octree::instance_count <<std::endl;
    std::cout<<"maximum depth: "<<Octree::maxDepth <<std::endl;

    std::cout<<" Serial Execution "<<std::endl;

    struct timeval start, end;
    gettimeofday(&start, NULL);

    octree_traverse(&init_octree);

    gettimeofday(&end, NULL);

    double delta = ((end.tv_sec  - start.tv_sec) * 1000000u + 
              end.tv_usec - start.tv_usec) / 1.e6;
    std::cout<<"serial exec time: "<<delta<<std::endl;
    
    struct timeval startp, endp;
    gettimeofday(&startp, NULL);


    #pragma omp parallel
    {
    #pragma omp single
    {
    octree_traverse_p(&init_octree);
    #pragma omp taskwait
    }}
    gettimeofday(&endp, NULL);
    double deltap = ((endp.tv_sec  - startp.tv_sec) * 1000000u + 
              endp.tv_usec - startp.tv_usec) / 1.e6;

    std::cout<<"parallel exec time: "<<deltap<<std::endl;

}

