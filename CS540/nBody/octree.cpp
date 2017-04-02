//octree.cpp

#include "octree.hpp"
#include <iostream>
#include <random>
#include <math.h>

Octree::Octree(NodePoint center, const double size, std::list<NodePoint> points){
    instance_count++;
    id = instance_count;
    m_center = center;
    m_size = size;
    //maxDepth = mDepth;
    m_points = points;
    m_depth = 0;
    setBounds();
}

Octree::Octree(NodePoint center, const double size, Octree *parent, std::list<NodePoint> points){
    instance_count++;
    id = instance_count;
    m_center = center;
    m_size = size;    
    m_depth = parent->getDepth()+1;
    m_parent = parent;
    setBounds();
//    printBounds();
//    split(maxDepth,points);

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
   // std::cout<<"    insert:" <<std::endl<<np.x<<std::endl<<np.y<<std::endl<<np.z<<std::endl;

    m_points.push_back(np);
}
void Octree::printBounds(){
    NodeBounds nb = this->getBounds();
    std::cout<<nb.xBound.upper<<":"<<nb.xBound.lower<<std::endl<<nb.yBound.upper<<":"<<nb.yBound.lower<<std::endl<<nb.zBound.upper<<":"<<nb.zBound.lower<<std::endl;
}

bool Octree::inBounds(NodePoint pointToCheck){
    std::cout<<"                    Checking in Bounds: "<<pointToCheck.x<<","<<pointToCheck.y<<","<<pointToCheck.z<<std::endl;
    if((pointToCheck.x <= m_nodeBounds.xBound.upper && pointToCheck.x >= m_nodeBounds.xBound.lower) &&
      (pointToCheck.y <= m_nodeBounds.yBound.upper && pointToCheck.y >= m_nodeBounds.yBound.lower) &&
      (pointToCheck.z <= m_nodeBounds.zBound.upper && pointToCheck.z >= m_nodeBounds.zBound.lower)){
            std::cout<<"                      IN BOUNDS"<<std::endl;
            return true;
    }
    else
            std::cout<<"                      OUT BOUNDS"<<std::endl;
        return false;
}

void Octree::split(std::list<NodePoint> points){
    std::cout<<std::endl;
    //1 check if we have less than the minimum number of points in us
    //also check if we are past max depth
    //if either of those are true we are a leaf
    std::cout<<" I am node "<<id<<std::endl;
    std::cout<<"  I have "<<points.size()<<" points"<<std::endl;
    if(m_depth >= maxDepth || points.size() <= 1){
        std::cout<<"   i am a leaf"<<std::endl;
        std::list<NodePoint>::const_iterator _it = points.begin();
        //while (_it != points.end()){
        std::cout<<"    size:"<<points.size()<<std::endl;
        for(_it=points.begin(); _it != points.end(); _it++){
            std::cout<<"potato"<<std::endl;
            insertPoint(points.back());
         }
    
        return;
    }
    else{

        std::cout<<"   i not a leaf, branching to children"<<std::endl;
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

            fur_childCenter.x = m_center.x+childDistance;
            fur_childCenter.y = m_center.y+childDistance;
            fur_childCenter.z = m_center.z+childDistance;
            
            ful_childCenter.x = m_center.x-childDistance;
            ful_childCenter.y = m_center.y+childDistance;
            ful_childCenter.z = m_center.z+childDistance;

            fdr_childCenter.x = m_center.x+childDistance;
            fdr_childCenter.y = m_center.y-childDistance;
            fdr_childCenter.z = m_center.z+childDistance;
            
            fdl_childCenter.x = m_center.x-childDistance;
            fdl_childCenter.y = m_center.y-childDistance;
            fdl_childCenter.z = m_center.z+childDistance;
             
            bur_childCenter.x = m_center.x+childDistance;
            bur_childCenter.y = m_center.y+childDistance;
            bur_childCenter.z = m_center.z-childDistance;
              
            bul_childCenter.x = m_center.x-childDistance;
            bul_childCenter.y = m_center.y+childDistance;
            bul_childCenter.z = m_center.z-childDistance;
              
            bdr_childCenter.x = m_center.x+childDistance;
            bdr_childCenter.y = m_center.y-childDistance;
            bdr_childCenter.z = m_center.z-childDistance;
              
            bdl_childCenter.x = m_center.x-childDistance;
            bdl_childCenter.y = m_center.y-childDistance;
            bdl_childCenter.z = m_center.z-childDistance;
            
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
                std::cout<<std::endl;
                std::cout<<"-------------------------------"<<std::endl;
                std::cout<<"-------------------------------"<<std::endl;
                std::cout<<"   checking node with bounds: "<<std::endl;
                it->printBounds(); 

                std::list<NodePoint>::const_iterator node_it = m_points.begin();
                while (node_it != m_points.end()){
                //for(node_it=m_points.begin(); node_it != m_points.end();){
                    if(it->inBounds(*node_it)) {
                        //int idx = node_it - m_points.begin();
                        it->insertPoint(*node_it);
                        //std::cout<<"              deleting: "<<idx<<std::endl;
                        node_it = m_points.erase(node_it);
                    }
                    else{
                        node_it++;
                    }
                }
            }
            std::cout<<"after cghecking all childs, theses are left:"<<std::endl;
            std::cout<<"  size: "<<m_points.size()<<std::endl;
            std::cout<<m_points.size()<<std::endl;
            std::list<NodePoint>::const_iterator node_it;
            for(node_it=m_points.begin(); node_it != m_points.end(); node_it++){
                std::cout<<"   "<<node_it->x<<std::endl;
                std::cout<<"   "<<node_it->y<<std::endl;
                std::cout<<"   "<<node_it->z<<std::endl;
            }
            if(m_points.size() != 0){
                std::cout<<std::endl;
                std::cout<<m_points.size()<<std::endl;
                std::cout<<std::endl;
                std::cout<<m_points.back().x<<std::endl;
                std::cout<<m_points.back().y<<std::endl;
                std::cout<<m_points.back().z<<std::endl;
                std::vector<Octree>::iterator it; 
                std::cout<<" COULD NOT PLACE: "<<std::endl;
                for(it=m_children.begin() ; it < m_children.end(); it++) {
                    std::cout<<std::endl;
                    it->printBounds();
                }
                std::cout<<" BAIL "<<std::endl;
                exit(0);
            }
            
            for(it=m_children.begin() ; it < m_children.end(); it++) {
                it->split(it->m_points);
            }
    }
}

int Octree::maxDepth = 4;

int numPoints = 10;
std::random_device rd;     // only used once to initialise (seed) engine
int randInt(int min, int max){
    //std::random_device rd;     // only used once to initialise (seed) engine
    std::mt19937 rng(rd());    // random-number engine used (Mersenne-Twister in this case)
    std::uniform_int_distribution<int> uni(min,max); // guaranteed unbiased

    auto random_integer = uni(rng);
    return random_integer;
}
int main(){
    int sim_size = 1000;
    double max_bound = cbrt(sim_size)/2;   
    NodePoint center;
    center.x = 0;
    center.y = 0;
    center.z = 0;
    
    std::list<NodePoint> initialPoints;
    for(int i; i<numPoints; ++i){
        NodePoint np;
        np.x = randInt(-max_bound,max_bound); 
        np.y = randInt(-max_bound,max_bound); 
        np.z = randInt(-max_bound,max_bound); 
        initialPoints.push_back(np);
    }
    /*
    NodePoint np1,np2,np3,np4,np5,np6,np7,np8;
    np1.x = 4;
    np1.y = 4;
    np1.z = 4;

    np2.x = -2;
    np2.y = 2;
    np2.z = 1;

    np3.x = 1;
    np3.y = -1;
    np3.z = 1;
  
    np4.x = 1;
    np4.y = 1;
    np4.z = -1;
  
    np5.x = -1;
    np5.y = -1;
    np5.z = 1;

    np6.x = 1;
    np6.y = -1;
    np6.z = -1;
  
    np7.x = -1;
    np7.y = 1;
    np7.z = -1;

    np8.x = -1;
    np8.y = -1;
    np8.z = -1;

    initialPoints.push_back(np1);
    initialPoints.push_back(np2);
    initialPoints.push_back(np3);
    initialPoints.push_back(np4);
    initialPoints.push_back(np5);
    initialPoints.push_back(np6);
    initialPoints.push_back(np7);
    initialPoints.push_back(np8);
    */

    Octree init_octree = Octree(center,1000,initialPoints);
    init_octree.split(initialPoints);

}

