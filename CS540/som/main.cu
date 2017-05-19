#include <GL/glut.h>
#include "constants.h"
#include "som.cuh"
#include <iostream>
#include "utils.h"
#include <time.h>
#include <sys/time.h>

void display(void);
void reshape(int width, int height);
void keyboard(unsigned char key, int x, int y);
void init();
void idle(void);

bool CUDA_ENABLED = false;
Som* som;

std::vector<std::vector<double> >m_TrainingSet;

struct timeval start, end;
bool timeDone = false;

void init()
{
  // initialize viewing system
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(45.0, 1.0, 1.0, 1000.0);
  glMatrixMode(GL_MODELVIEW);

  // initialize background color to black
  glClearColor(0.0,0.0,0.0,0.0);

  // enable depth buffering
  glEnable(GL_DEPTH_TEST);
}

void display()
{
    // clear buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // compute eye position
    glLoadIdentity();

    gluLookAt(50,50,200, 50,50,0, 0,1,0);

    // draw the current map
    som->render();

    // draw to screen
    glutSwapBuffers();
}

void reshape(int width, int height)
{
  glViewport(0, 0, (GLsizei) width, (GLsizei) height);
}


bool Train()
{
    if(!som->finishedTraining()){
        if(CUDA_ENABLED)
            som->cudaEpoch(m_TrainingSet);
        else
            som->epoch(m_TrainingSet);
    }
    return som->finishedTraining();
}

void clockOut(){
    if(!timeDone){
        gettimeofday(&end, NULL);
        double delta = ((end.tv_sec  - start.tv_sec) * 1000000u +
        end.tv_usec - start.tv_usec) / 1.e6;
        std::cout<<std::endl<<"exec time: "<<delta<<std::endl;
        timeDone = true;
    }
}

void idle(void)
{
    if(!Train()){
        std::cout<<"\r Epoch: "<<som->getIteration()<<" / "<<constNumIterations;
        glutPostRedisplay();
    }
    else{
        clockOut();
    }
}


void createDataSet(bool randomData)
{

if(!randomData){

  //create a data set
  std::vector<double> red, green, blue, yellow, orange, purple, dk_green, dk_blue;

  red.push_back(1);
  red.push_back(0);
  red.push_back(0);

  green.push_back(0);
  green.push_back(1);
  green.push_back(0);

  dk_green.push_back(0);
  dk_green.push_back(0.5);
  dk_green.push_back(0.25);

  blue.push_back(0);
  blue.push_back(0);
  blue.push_back(1);

  dk_blue.push_back(0);
  dk_blue.push_back(0);
  dk_blue.push_back(0.5);

  yellow.push_back(1);
  yellow.push_back(1);
  yellow.push_back(0.2);

  orange.push_back(1);
  orange.push_back(0.4);
  orange.push_back(0.25);

  purple.push_back(1);
  purple.push_back(0);
  purple.push_back(1);

  m_TrainingSet.push_back(red);
  m_TrainingSet.push_back(green);
  m_TrainingSet.push_back(blue);
  m_TrainingSet.push_back(yellow);
  m_TrainingSet.push_back(orange);
  m_TrainingSet.push_back(purple);
  m_TrainingSet.push_back(dk_green);
  m_TrainingSet.push_back(dk_blue);

}
else{
  //choose a random number of training sets
  int NumSets = RandInt(constMinNumTrainingSets, constMaxNumTrainingSets);

  for (int s=0; s<NumSets; ++s)
  {

    vector<double> set;

    set.push_back(RandFloat());
    set.push_back(RandFloat());
    set.push_back(RandFloat());

    m_TrainingSet.push_back(set);
  }
 }
    
}

void usage(){
    std::cout<<"                 Color Organizing SOM"<<std::endl;
    std::cout<<"Uses a self organizing map to cluster 3 dimensional colors(R,G,B) in 2D space(X,Y)"<<std::endl;
    std::cout<<"   Usage:"<<std::endl;
    std::cout<<"        ./som [-r]"<<std::endl;
    std::cout<<"        -r   :   use random colors to train"<<std::endl;
        
    
}

main(int argc, char **argv){
    srand((unsigned) time(NULL));
    gettimeofday(&start, NULL);

    bool randomTrainingData = false;
    if(argc > 1){
        for(int i = 1; i < argc; ++i){
            if((string)argv[i] == "-r"){
                randomTrainingData = true;
                std::cout<<"Creating random training data"<<std::endl;
            }
            else if((string)argv[i] == "-c"){
                CUDA_ENABLED = true;
                std::cout<<"CUDA Parallelization enabled"<<std::endl;
            }

            else if((string)argv[1] == "-h"){
                usage();
                exit(1);
            }
            else
                std::cout<<"Not a valid arg: "<<argv[1]<<std::endl;
        }
    }
    createDataSet(randomTrainingData);
    som = new Som();
    som->finishedTraining();
    som->create(constNumCellsAcross, constNumCellsDown, constNumIterations);
    // set up window
    glutInitWindowSize(400, 400);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutCreateWindow("Self-organizing Map Demo");
    // register callback functions
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    
    // initalize opengl parameters
    init();
    // loop until something happens
    glutMainLoop();

    delete som;
    return 0;
}


