%Parabolic Runout Spline
%you have a printed version
x = [-10 0 10 20 30];
y = [.99815 .99987 .99973 .99823 .99567];
xx = -10:..01:30;
h = 10;
A = [[5 1 0];[1 4 1];[0 1 5]];
B =(6/(h^2))*[(y(1)-2*y(2))+y(3)); (y(2)-(2*y(3))+y(4)); (y(3)-(2*y(4))+y(5))];
Mtemp = inv(A)*B;
M = zeros(5,1);
M(1) = Mtemp(1);M(2) = Mtemp(1);M(3) = Mtemp(2); M(4) = Mtemp(3);M(5) = Mtemp(3);
a = zeros(5,1); b = zeros(5,1); c = zeros(5,1); d = zeros(5,1);

for i = i:4
    a(i) = (M(i+1) - M(i))/(6*h);
    b(i) = M(i)/2;
    c(i) = ((y(i+1)-y(i))/h - (M(i+1)+2*M(i))*h/6);
    d(i) = y(i);
end
