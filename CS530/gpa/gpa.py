import matplotlib.pyplot as plt
import numpy as np
import math

data = np.genfromtxt('GPA_Reg.csv',delimiter=',');

data = np.transpose(data)

x = np.delete(data[0],0)
y = np.delete(data[1],0)

def getMu(vec):
    _mu = 0
    for i in range (0,len(vec)):
        _mu += vec[i]
    return _mu/len(vec)

def getR(x_vec, y_vec):
    x_mu = getMu(x_vec)
    y_mu = getMu(y_vec)
    nume = 0
    x_2 = 0
    y_2 = 0
    for i in range(0,len(x_vec)):
        x = x_vec[i]-x_mu
        y = y_vec[i]-y_mu
        nume += x*y
        x_2 += x**2
        y_2 += y**2
    return nume/(math.sqrt(x_2*y_2))

def stdDev(vec):
    _mu = getMu(vec)
    sum_vec = 0
    for i in range(0,len(vec)):
        sum_vec += (vec[i] - _mu)**2
    return(math.sqrt((sum_vec)/len(vec)))

def estimateY(x,m,b):
    return (m*x)+b
def plot(x,y,m,b):
    plt.plot(x,y, 'yo', x, estimateY(x,m,b), '--k')
    plt.show()

def main():
    data = np.genfromtxt('GPA_Reg.csv',delimiter=',');
    data = np.transpose(data)
    x = np.delete(data[0],0)
    y = np.delete(data[1],0)

    r = getR(x,y)
    
    stdX = stdDev(x)
    stdY = stdDev(y)

    m = r*(stdY/stdX)
    b = getMu(y)-(m*getMu(x))
    plot(x,y,m,b) 

if __name__ == "__main__":
    main()
