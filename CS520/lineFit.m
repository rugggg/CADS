%line fitting in class work
%first method is usign all built in matlab functions
x = [1 2 3 4 5];
y = [3 1 4 8 12];
p = polyfit(x,y,2);
xx = [0:0.01:5];
yy = polyval(p,xx);
plot(x,y,'o',xx,yy,'r'); %uncomment to show plot

%second method is using least squares

B = [sum(x.^4) sum(x.^3) sum(x.^2);
    sum(x.^3) sum(x.^2) sum(x);
    sum(x.^2) sum(x) 5]

Z = [sum(x.^2.*y) sum(x.*y) sum(y)]  %note that this gives you one row, 3 col. we
                                    % we will use transpose later, but we
                                    % would totally use semicolons here to
                                    % not have to use transpose
coeff2 = inv(B)*Z'

%Now using the third method

A = [(x.^2)' x' ones(5,1)]
coeff1 = inv(A'*A)*(A'*y')




