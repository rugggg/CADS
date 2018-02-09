A = imread('../Cat.jpg');
B = imread('../Moon.jpg');

# fade one image into another
# pointwise operation

# so given A(i,j) = x and B(i,j) = y:
#   x + ((y-x)/15)
#   x + 2((y-x)/15)
#    ....
#   x + i((y-x)/15)
step = A;
for i=1:15
  step = A + i*((B-A)/15);
  imshow(step)
  drawnow
end
