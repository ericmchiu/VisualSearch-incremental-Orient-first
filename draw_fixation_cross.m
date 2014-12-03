function draw_fixation_cross()

global width height im

% set im to white
im = uint8(ones(height,width,3).*255); 
% set a few pixel in the middel to black
x_center = floor(width/2);
y_center = floor(height/2);

offset = 25;

im(  y_center-1:y_center+1, (x_center  - offset):( x_center + offset ) ,:) = 0;
im( (y_center - offset):(y_center + offset), x_center-1:x_center+1 ,:) = 0;

image(im)

axis off

drawnow;