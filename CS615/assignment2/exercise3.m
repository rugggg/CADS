I = imread('../images/Cat.jpg');
subplot(2,2,1);
colormap(gray),imagesc(I);
# histogram equalization/flattening

# first step is to get number of pixels in image
numPixels = size(I,1) *size(I,2)

# then we will iterate over the pixels, creating an 
# array for our historgram as we go.
# as this is a 256 image, the histogram will be
# 256 elements long zeros to start
#max(max(I))
hist = zeros(255,1);

# then for each possible intensity, get the num
# of occurences and store in hist
# loop it
for i=0:255
  hist(i+1) = sum(sum(I==i));
end
subplot(2,2,2);
plot(hist)
pk = hist/(size(I,1)*size(I,2));
sum(pk); # == 1

J1 = pk(I+1);

J = round(((size(I,1)*size(I,2))-1)*J1+0.5);
subplot(2,2,3);
colormap(gray),imagesc(J);

histJ = zeros(255,1);

for i=0:255
  histJ(i+1) = sum(sum(J==i));
end

subplot(2,2,4);
plot(histJ)