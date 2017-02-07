% Use ode45 to solve our ODE
% Place the time points in a vector 't'
% Place the solution in a vector 'x'
options = odeset('RelTol', 1e-4,'NonNegative', [1 2]);


%   dx/dt = ax - bxy - cx^2
%   dy/dt = ny + mxy - py^2
%
%   
%   x = (p-n)/m    y = (a/b)+c(n-p)/bm
%   x = a/c        y = 0
time_range = [0 10];
x0y0 = [20 10];
syms x y
vars = [x, y];

a = 3; 
b = 4; 
c = 0;
n = 1;
m = 1;
p = 1;


[t,pops] = ode45(@fox_rabbit_food, time_range, x0y0,a,b,c,m,n,p, options);
figure
subplot(2,1,1)
plot(t,pops);
legend('rabbits', 'foxes');


for i=1:10
    for j=1:10
        [t,y]=ode45(@predPrey,[0:.1:1],[i,j],a,b,c,m,n,p); %first arg is range to plot, second is intial condition
        subplot(2,1,2)
        plot(y(:,1),y(:,2),'b');
        hold on
    end
end

