A = imread('mammogram.jpg');

find(A==3);
find(A < 3);

# logical -> makes it 1 if true, 0 else
result1 = [A > 155];
colormap(gray),imagesc(result1)

# from his code
I=imread('mammogram.jpg');
I=double(I);
Tnew=.5(max(I(:))+min(I(:)));
Told=0;
T0=10^(-8)
while(abs(Tnew-Told)>T))
  Q1=I((I>Tnew));
  Q2=I((I<Tnew));
  x1=mean(Q1);
  x2=mean(Q2);
  
  Told=Tnew;
  Tnew=mean([x1,x2]);
end

result=(I>Tnew)
colormap(gray)
subplot(1,2,1)