A = imread('mammogram.jpg');

find(A==3);
find(A < 3);

# logical -> makes it 1 if true, 0 else
result1 = [A > 155];
colormap(gray),imagesc(result1)

