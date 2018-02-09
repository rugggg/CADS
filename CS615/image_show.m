I = imread('Moon.jpg');
A = double(I);


subplot(2,2,1)
colormap(gray), imagesc(A)

# just modify a bit 
B = .01*A;
subplot(2,2,2)
colormap(gray), imshow(B)

# invert 
C = -1*A;
subplot(2,2,3)
colormap(gray), imagesc(C)


# cross lines 
D = A;
for i=1:256
  D(i,i) = 0;
  D(257-i,i) = 0;
end
subplot(2,2,4)
colormap(gray), imagesc(D)

