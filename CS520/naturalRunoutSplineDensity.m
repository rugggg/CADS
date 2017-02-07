%Natural Spline

x = [-10 0 10 20 30];% CHANGE
y = [.99815 .99987 .99973 .99823 .99567]; % CHANGE
xx = x(1):.01:x(length(x));
h = x(2)-x(1);

A = [ % CHANGE according to size and also runout type
  [5 1 0];
  [1 4 1];
  [0 1 5]
 ];
 
tempB = zeros(length(x)-2,1);

for i = 1:length(tempB)
  tempB(i) = (y(i)-(2*y(i+1))+y(i+2));
end

B =(6/(h^2))*[
  tempB
];
%Bold =(6/(h^2))*[(y(1)-(2*y(2))+y(3)); (y(2)-(2*y(3))+y(4)); (y(3)-(2*y(4))+y(5))];

Mtemp = inv(A)*B; % CHANGE the name of Mtemp if needed
M = zeros(length(x),1);
for i = 1:length(x)
  if(i == 1 || i == length(x))
    M(i) = 0;
  else(i == length(x))
    M(i) = Mtemp(length(x)-2);
  end
end
M

a = zeros(length(x),1); b = zeros(length(x),1); c = zeros(length(x),1); d = zeros(length(x),1);

for i = 1:length(x)-1
    a(i) = (M(i+1) - M(i))/(6*h);
    b(i) = M(i)/2;
    c(i) = ((y(i+1)-y(i))/h - (M(i+1)+2*M(i))*h/6);
    d(i) = y(i);
end
rs = zeros(1,length(xx));

for j = 1:length(xx)
  z = xx(j);
  %if(x(1) <=z && z<x(2))
  %  i = 1;
  %elseif(x(2) <= z && z < x(3))
  %  i = 2;
  %lseif(x(3) <= z && z < x(4))
  %  i = 3;
  %else 
  %  i = 4;
  %end
  
  i = -1;
  for k = 1:length(x)-2
    if(x(k) <= z && z < x(k+1))
      i = k;
      break;
    end
  end
  if(i == -1)
    i = length(x)-1;
  end
  rs(j) = a(i)*(z-x(i))^3 +b(i)*(z-x(i))^2 +c(i)*(z-x(i)) +d(i);
end


p2 = [a(2) b(2) c(2) d(2)]
q = polyder(p2);
r = roots(q);

plot(x,y,'o',xx,rs,'g',r(2),max(rs),'*r');
title('Natural Spline') % CHANGE the name lol
xlabel('Temp')
ylabel('Density {\it (g/{cm}^3})')
format long
text(6,1.0002,['Maximum density occurs at (',num2str(r(2)),',',num2str(max(rs)),')'],'FontSize',12)


hold on
grid on