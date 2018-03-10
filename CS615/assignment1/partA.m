I = imread('../images/spot.jpg');
# get average optical density of image
# dont loop as that's slow and defeats
# the point of matlab
# both of below methods are identical
mean(I(:))
sum(sum(I))/(size(I,1)*size(I,2))