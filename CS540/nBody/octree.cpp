//octree.cpp

#include "octree.hpp"
#include <iostream>
#include <math.h>

Octree::Octree(NodePoint center, const double size, int maxDepth, std::vector<NodePoint> points){
    instance_count++;
    std::cout<<"   Instance: "<<instance_count<<std::endl;
    m_center = center;
    m_size = size;
    m_maxDepth = maxDepth;
    m_points = points;
    m_depth = 0;
    std::cout<<points.size()<<std::endl;
    setBounds();
//    printBounds();
}

Octree::Octree(NodePoint center, const double size, Octree *parent, int maxDepth, std::vector<NodePoint> points){
    instance_count++;
    std::cout<<"   Instance: "<<instance_count<<std::endl;
    m_center = center;
    m_size = size;    
    m_depth = parent->getDepth()+1;
    m_parent = parent;
    m_maxDepth = maxDepth;
    setBounds();
//    printBounds();
    std::cout<<"++ Point Size = "<<points.size()<<std::endl;
    split(maxDepth,points);
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

std::vector<NodePoint> Octree::getPoints(){
    return m_points;
}

void Octree::insertPoint(NodePoint np){
    std::cout<<"    insert:" <<np.x<<std::endl;
    m_points.push_back(np);
}
void Octree::printBounds(){
    NodeBounds nb = this->getBounds();
    std::cout<<nb.xBound.upper<<":"<<nb.xBound.lower<<std::endl<<nb.yBound.upper<<":"<<nb.yBound.lower<<std::endl<<nb.zBound.upper<<":"<<nb.zBound.lower<<std::endl;
}

bool Octree::inBounds(NodePoint pointToCheck){
    if(pointToCheck.x >= m_nodeBounds.xBound.upper || pointToCheck.x <= m_nodeBounds.xBound.lower){
            return false;
    }
   if(pointToCheck.y >= m_nodeBounds.yBound.upper || pointToCheck.y <= m_nodeBounds.yBound.lower){
            return false;
    }
    if(pointToCheck.z >= m_nodeBounds.zBound.upper || pointToCheck.z <= m_nodeBounds.zBound.lower){
            return false;
    }
    return true;
}

void Octree::split(int maxDepth,std::vector<NodePoint> points){
    //1 check if we have less than the minimum number of points in us
    //also check if we are past max depth
    //if either of those are true we are a leaf
    std::cout<<"  split -> my depth: "<<m_depth<<" max: "<<maxDepth<<std::endl;
    if(m_depth >= maxDepth || points.size() <= 2){
        std::cout<<"I am a leaf"<<std::endl; 
        std::vector<NodePoint>::iterator _it;  // declare an iterator to a vector of strings
         for(_it=points.begin(); _it < points.end(); _it++){
            insertPoint(points.back());
            points.pop_back();
         }
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
            
            std::cout<<"  potato: "<<m_points.size()<<std::endl; 
            Octree fur = Octree(fur_childCenter,childSize,this,m_maxDepth,m_points);
            Octree ful = Octree(ful_childCenter,childSize,this,m_maxDepth,m_points);
            Octree fdr = Octree(fdr_childCenter,childSize,this,m_maxDepth,m_points);
            Octree fdl = Octree(fdl_childCenter,childSize,this,m_maxDepth,m_points);
            Octree bur = Octree(bur_childCenter,childSize,this,m_maxDepth,m_points);
            Octree bul = Octree(bul_childCenter,childSize,this,m_maxDepth,m_points);
            Octree bdr = Octree(bdr_childCenter,childSize,this,m_maxDepth,m_points);
            Octree bdl = Octree(bdl_childCenter,childSize,this,m_maxDepth,m_points);
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
                std::vector<NodePoint>::iterator node_it;
                for(node_it=m_points.begin(); node_it < m_points.end(); node_it++){
                    if(inBounds(*node_it)) {
                        it->insertPoint(m_points.back());
                        m_points.pop_back();
                    }
                }
            }
            std::cout<<"I should be ZERO: "<<m_points.size()<<std::endl;
            if(m_points.size() != 0){
                std::cout<<" BAIL "<<std::endl;
                exit(0);
            }
    }
}

int main(){
    std::cout<<"Main"<<std::endl;
    NodePoint center;
    center.x = 0;
    center.y = 0;
    center.z = 0;
    
    std::vector<NodePoint> initialPoints;
    NodePoint np1,np2,np3,np4,np5,np6,np7,np8;
    np1.x = 4;
    np1.y = 1;
    np1.z = 1;

    np2.x = -1;
    np2.y = 1;
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


    int maxDepth = 2;

    Octree init_octree = Octree(center,1000,maxDepth,initialPoints);
    init_octree.split(maxDepth,initialPoints);

}

