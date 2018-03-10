A = imread('../images/mammogram.jpg');
# logical -> makes it 1 if true, 0 else
result1 = [A > 155];
subplot(2,2,1);
colormap(gray),imagesc(result1)

# from his code - doing it manually
I=imread('../images/mammogram.jpg');
I=double(I);
Tnew=.5*(max(I(:))+min(I(:)));
Told=0;
T0=10^(-8)
while(abs(Tnew-Told)>I)
  Q1=I((I>Tnew));
  Q2=I((I<Tnew));
  x1=mean(Q1);
  x2=mean(Q2);
  
  Told=Tnew;
  Tnew=mean([x1,x2]);
end

result=(I>Tnew);
colormap(gray);
subplot(2,2,2);
colormap(gray),imagesc(result);

# Approx Contour Generation
# take binary image
# define a second image J
# J(i,j) = 0 if I(i,j) has is black
# and has a white neighbor
J = 255*ones(size(result,1), size(result,2),'uint8');
for i=1:size(result,1)
  for j=1:size(result,2)
    if result(i,j) == 0
      if result(i+1,j) > 0
        J(i,j) = 0;
      elseif result(i-1,j) > 0
        J(i,j) = 0;
      elseif result(i,j+1) > 0
        J(i,j) = 0;
      elseif result(i,j-1) > 0
        J(i,j) = 0;
      end
    end
  end
end
subplot(2,2,3);
colormap(gray),imagesc(J);

 