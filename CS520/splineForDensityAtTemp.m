%High chance this is on test. With different end params

temp = [-10 0 10 20 30];
dens = [.99815 .99987 .99973 .99823 .99567];



A = [5 1 0;1 4 1;0 1 5];
x = [-.0001116; -.0000816; -.0000636];

M = linsolve(A,x);

%from i = 2...n-1
%ai = (Mi+1 - Mi)/6h
%bi = Mi/2
%ci = ((yi+1 - yi)/h)-(((Mi+1+2Mi)/6)h))
%di = yi
for i = 1:size(M)-2
    a(i) = (M(i+1)-M(i))/60
end
        
a


