#ifndef CONSTANTS_H
#define CONSTANTS_H



const int constWindowWidth       = 100;
const int constWindowHeight      = 100;

const int constNumCellsAcross    = 10;
const int constNumCellsDown      = 10;


//number of weights each node must contain. One for each element of 
//the input vector. In this example it is 3 because a color is
//represented by its red, green and blue components. (RGB)
const int     constSizeOfInputVector   = 3;

//the number of epochs desired for the training
const int    constNumIterations       = 10;

//the value of the learning rate at the start of training
const double constStartLearningRate   = 0.9;

/*   uncomment the following if you'd like the SOM to classify randomly created training sets  */

#define RANDOM_TRAINING_SETS

#ifdef RANDOM_TRAINING_SETS

const int    constMaxNumTrainingSets  = 20;
const int    constMinNumTrainingSets  = 5;

#endif

#endif
