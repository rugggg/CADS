        I = imread('eight.tif');
        J = imnoise(I,'salt & pepper',0.02);
        K = medfilt2(J);
        Mask=(1/9)*[1 1 1;1 1 1;1 1 1];
        L=imfilter(J,Mask,'replicate');
        colormap(gray)
        subplot(2,2,1), imshow(I)
        subplot(2,2,2), imshow(J)
        subplot(2,2,3), imshow(K)
        subplot(2,2,4), imshow(L)
        