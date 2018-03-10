clear

A=imread('objects.jpg');
A=rgb2gray(A);
A=double(A);
colormap(gray)

b=A(209:257,190:240);

C=imfilter(A,b,'replicate');

thresh=max(C(:));
D=(C>thresh);

subplot(2,2,1), imagesc(A)
subplot(2,2,2), imagesc(b)
subplot(2,2,3), imagesc(C)
subplot(2,2,4), imagesc(D)


