function draw_fixation_cross()

global width height

im( uint16(width/2-8):uint16(width/2+8), ...
    uint16(height/2-5):uint16(height/2+5),:) = 0;
image(im)
axis off
drawnow;