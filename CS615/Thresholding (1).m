I=imread('mammogram.jpg');
I=double(I);
Tnew=.5*(max(I(:))+min(I(:)));
Told=0;
T0=10^(-8);
while(abs(Tnew-Told)>T0)
    G1=I((I>Tnew));
    G2=I((I<=Tnew));
    x1=mean(G1);
    x2=mean(G2);
    
    Told=Tnew;
    Tnew=mean([x1,x2]);
end
result=(I>Tnew);
colormap(gray)
subplot(1,2,1),imagesc(I)
subplot(1,2,2),imagesc(result)

