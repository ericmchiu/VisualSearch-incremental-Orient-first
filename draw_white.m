function draw_white()

global width height

im = uint8(zeros(width,height,3)+255); % Create white display and show
image(im)
axis off
drawnow;