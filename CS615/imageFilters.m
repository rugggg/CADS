I = imread('eight.tif');
J = imnoise(I, 'salt & pepper', 0.02);
K = medfilt2(J);
Mask=(1/9)*[1 1 1;1 1 1;1 1 1];
L = imfilter(J, Mask, 'replicate')
colormap(gray)
subplot(2,2,1)
subplot(2,2,2)
subplot(2,2,3)
subplot(2,2,4)
