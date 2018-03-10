pkg load image

I = imread('images/cameraman.jpg');

# use builtin
edge(I, "Sobel")

prewitty = [-1, 0, 1;
            -1, 0, 1;
            -1, 0, 1];
         
prewittx = [-1, -1, -1;
             0, 0, 0;
             1, 1 ,1];   
Y = double(imfilter(I, prewitty *(1/3)));
X = double(imfilter(I, prewittx *(1/3)));

R = (Y >= 6);
C = (X >= 6);

subplot(2,2,1)
colormap(gray),imagesc(I)
   
subplot(2,2,2)
colormap(gray),imagesc(C)

subplot(2,2,3)
colormap(gray),imagesc(R)

M=sqrt((Y.^2 + X.^2));
newImageY = (M>=6);

subplot(2,2,4)
colormap(gray),imagesc(newImageY)