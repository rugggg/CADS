import numpy as np
'''
input_data = np.array([[-1,-1,1],[-1,1,1],[1,-1,1],[1,1,1]])
truth = np.array([[-1,1,1,-1]]).T
'''
def sigma(x,is_sigmoid=False):
    if(is_sigmoid):
        return x*(1-x)
    return 1/(1+np.exp(-x))

def process_layer(inputs,layer_weights):
    return sigma(np.dot(inputs,layer_weights))

'''
epochs = 10
np.random.seed(1)
layer0 = 2*np.random.random((3,4)) - 1
layer1 = 2*np.random.random((4,1)) - 1
'''
input_data = np.array([ [0,0,1],[0,1,1],[1,0,1],[1,1,1] ])
truth = np.array([[0,1,1,0]]).T
w0 = 2*np.random.random((3,4)) - 1
w1 = 2*np.random.random((4,1)) - 1
weights = [w0,w1]
for i in range(60000):
    layer1 = process_layer(input_data,w0)
    layer2 = process_layer(layer1,w1)
    layer2_delta = (truth - layer2)*(layer2*(1-layer2))
    layer1_delta = layer2_delta.dot(w1.T) * (layer1 * (1-layer1))
    w1 += layer1.T.dot(layer2_delta)
    w0 += input_data.T.dot(layer1_delta)
'''
for i in range(epochs):
    # forward propagation
    output1 = process_layer(input_data,layer0)
    output2 = process_layer(output1,layer1)

    #output layer delta and adjustment
    output_error = truth - output2
    if (i% 10000) == 0:
        print("Error:" + str(np.mean(np.abs(output_error))))
    output_delta = output_error*sigma(output2,True)
    #layer 1 delta and adjustment
    output1_error = output_delta.dot(layer1.T)

    output1_delta = output1_error * sigma(output1,True)

    layer1 += output2.T.dot(output_delta)
    layer0 += output1.T.dot(output1_delta)
   ''' 



