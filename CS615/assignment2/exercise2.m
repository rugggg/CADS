# binary template matching
#  take some template from the image,
# like a point of light for a star
# and use that as template to match
# then center that over each pixel in image
# load spot image
I = imread('../images/spot.jpg');
subplot(2,2,1);
colormap(gray),imagesc(I);

# then let use select our template as an all white 3x3
# as we are looking for spots of light in the image
templateXoffset = 4;
templateYoffset = 4;

# dummy template does us no good here
# need to pick an actual piece of the image
template = 255*ones((templateXoffset*2)+1, (templateYoffset*2)+1,'uint8');
template = I((65:74),(95:104));
subplot(2,2,2);
colormap(gray),imagesc(template)
J = 255*zeros(size(I,1), size(I,2),'uint8');

# iterate over each pixel in image and replace
# point in new image J with the sum of template

# let's say ii and jj are the width to each side/up/down
# to check 
for i=1+templateXoffset:(size(I,1)-(1+templateXoffset))
  for j=1+templateYoffset:(size(I,2)-(1+templateYoffset))
    point = I(i,j);
    jValue = 0;
    # match template
    # check center point first
    # template centers
    txc = templateXoffset+1;
    tyc = templateYoffset+1;

    if template(templateXoffset+1,templateYoffset+1) == I(i,j)
      jValue = jValue + 1;
    end
    # now go around each point in the template
    # and check for equality
    for ii=1:templateXoffset
      for jj=1:templateYoffset
        # if the two points are same, add 1
        # check all points around
        if I(i+ii,j+jj) == template(txc+ii,tyc+jj)
          jValue += 1;
        end
        if I(i,j+jj) == template(txc,tyc+jj)
          jValue += 1;
        end
        if I(i-ii,j+jj) == template(txc-ii,tyc+jj)
          jValue += 1;
        end
        if I(i-ii,j) == template(txc+ii,tyc+jj)
          jValue += 1;
        end
        if I(i+ii,j) == template(txc+ii,tyc+jj)
          jValue += 1;
        end
        if I(i+ii,j-jj) == template(txc+ii,tyc+jj)
          jValue += 1;
        end
        if I(i,j-jj) == template(txc,tyc+jj)
          jValue += 1;
        end
        if I(i-ii,j-jj) == template(txc-ii,tyc+jj)
          jValue += 1;
        end
        end
    J(i,j) = jValue;
    jValue;
    end
  end

end
subplot(2,2,3);
colormap(gray),imagesc(J);


J2 = [J < 15];
subplot(2,2,4);
colormap(gray),imagesc(J2);