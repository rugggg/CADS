%initial values
x = [-10 0 10 20 30];
y = [.99815 .99987 .99973 .99823 .99567]; 
h = x(2)-x(1)

a = zeros(length(x),1);
b = zeros(length(x),1);
c = zeros(length(x),1);
d = zeros(length(x),1);


for i = 1:length(x)-1
    a(i) = (M(i+1) - M(i))/(6*h);
    b(i) = M(i)/2;
    c(i) = ((y(i+1)-y(i))/h - (M(i+1)+2*M(i))*h/6);
    d(i) = y(i);
end

tempB = zeros(length(x)-1,1);

for i = 1:length(tempB)
  tempB(i) = (y(i)-(2*y(i+1))+y(i+2));
end

B =(6/(h^2))*[
  tempB
]