import numpy as np

def sigma(x,is_sigmoid=False):
    if(is_sigmoid):
        return x*(1-x)
    return 1/(1+np.exp(-x))

def process_layer(inputs,layer_weights):
    return sigma(np.dot(inputs,layer_weights))

#setup input data and truth
input_data = np.array([ [0,0,1],[0,1,1],[1,0,1],[1,1,1] ])
truth = np.array([[0,1,1,0]]).T
#weight init
w0 = 2*np.random.random((3,4)) - 1
w1 = 2*np.random.random((4,1)) - 1
w = [w0,w1]

epochs = 500000
for i in range(epochs):
    #forward propogation
    layer1 = process_layer(input_data,w[0])
    layer2 = process_layer(layer1,w[1])
    #calculate error
    output_error = truth - layer2
    if (i% 10000) == 0:
        print("Error:" + str(np.mean(np.abs(output_error))))
    #begin backprop with delta calculations
    layer2_delta = output_error*sigma(layer2,True)
    layer1_delta = layer2_delta.dot(w[1].T)*sigma(layer1,True)
    #update weights
    w[1] += layer1.T.dot(layer2_delta)
    w[0] += input_data.T.dot(layer1_delta)

print(w)
