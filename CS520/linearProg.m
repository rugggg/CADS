w = linspace(0,1,100);
c = linspace(0,1,100);
x1 = w + c <= 45;
x2 = 3*w + 2*c <=100;
x3 = 2*w + 4*c <=120;

figure
plot(x1,x2,x3)