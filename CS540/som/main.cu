#include <GL/glut.h>
#include "constants.h"
#include "som.cuh"
#include <iostream>
#include "utils.h"
#include <time.h>

void display(void);
void reshape(int width, int height);
void keyboard(unsigned char key, int x, int y);
void init();
void idle(void);



Som* som;

std::vector<std::vector<double> >m_TrainingSet;

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
  if (!som->finishedTraining())
  {
    if (!som->epoch(m_TrainingSet))
    {
      return false;
    }
  }

  return true;
}


void idle(void)
{
    if(Train())
        glutPostRedisplay();
    else
        std::cout<<"Training Over"<<std::endl;
}

void keyboard(unsigned char key, int mouseX, int mouseY)
{
    switch (key)
    {
    case 't':
        som->flipDone();
        break;
    case 'r':
        som = new Som();
        som->finishedTraining();
        som->create(10, 10, 2);
        std::cout << "Map reset" << std::endl;
        glutPostRedisplay();
        break;
    }
}


void createDataSet()
{

#ifndef RANDOM_TRAINING_SETS

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


#else

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

#endif

}

main(int argc, char **argv){
    srand((unsigned) time(NULL));
    createDataSet();
    som = new Som();
    som->finishedTraining();
    som->create(100, 100, 2);
    // set up window
    glutInitWindowSize(400, 400);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutCreateWindow("Self-organizing Map Demo");
    // register callback functions
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutKeyboardFunc(keyboard);
    glutIdleFunc(idle);
    
    // initalize opengl parameters
    init();
    // loop until something happens
    glutMainLoop();

    delete som;
    return 0;
}


