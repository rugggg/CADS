# PART C
I = imread('../images/spot.jpg');
A = min(min(I))
B = max(max(I))
B = 50

subplot(2,2,1)
hist(I)
subplot(2,2,2)
colormap(gray),imagesc(I)
I = (255/B-A).*(I.-A);

subplot(2,2,3)
hist(I)

subplot(2,2,4)
colormap(gray),imagesc(I)