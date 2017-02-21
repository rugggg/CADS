% fox_rabbit_food.m
%
%   dx/dt = ax - bxy - cx^2
%   dy/dt = ny + mxy - py^2
%
% Inputs:
%   t - Time variable
%   pops - Independent variable: this contains both populations (x and y)
% Output:
%   dpop - First derivative: the rate of change of the populations
function dpop = fox_rabbit_food(t, pops,a,b,c,m,n,p)
  dpop = [0; 0];
  dpop(1) = a * pops(1) - b * pops(1) * pops(2) - c * pops(1)^2; 
  dpop(2) = n * pops(2) + m * pops(1) * pops(2) - p * pops(2)^2;
