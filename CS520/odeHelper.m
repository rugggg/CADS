function yp = odeHelper(t,y)

%this file is a function definition
%for using with solving a system of ODE

xx = y(1);
yy = y(2);
yp1 = -2*xx*yy -1*xx; %yp1 and yp1 are your system of ODEs, these will 
yp2 = 1.2*xx*yy - .3*yy; %have the most impact on the graph and result 
yp = [yp1; yp2];