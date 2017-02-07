function yp = predPrey(t,y,a,b,c,m,n,p)

%this file is a function definition
%for using with solving a system of ODE

xx = y(1);
yy = y(2);

yp1 = a*xx-b*xx*yy-c*xx^2; %yp1 and yp1 are your system of ODEs, these will 
yp2 = n*yy+m*xx*yy-p*yy^2; %have the most impact on the graph and result 
yp = [yp1; yp2];