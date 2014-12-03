function create_display(rv,rh,gv,gh, field, stimulus_type, always_draw_all_stimuli)

global width height im im_color_cue im_align_cue
global margin mindist long short 
global visual_queue_pause

darkgreen   = 160;                          % Darker green

% Put the list together
% disp([rv rh gv gh])
list = [ones(1,rv) ones(1,rh)*2 ones(1,gv)*3 ones(1,gh)*4];
    % Type 1 = rv - red vertical
    % Type 2 = rh - red horizontal
    % Type 3 = gv - green vertical
    % Type 4 = gh - green horizontal
    % REMEMBER: x values are associated to width, but in the second dimension
    % for im!!! Use im(y,x) to get to width x and height y!

list = list(randperm(length(list))); % Permute

for i = 1:length(list)
    
    if list(i)==1 || list(i)==3 % translate long/short into actual x,y
        % verticals
        xe = short;
        ye = long;
        
    else
        % horizontals
        xe = long; % width is long
        ye = short;% height is short
    end;
    
    found = false;
    
    while found == false % Search for a non-overlapping point
        
        % Find a random point that respects margin and shape
        % margin = 10; xe = width of object; width = width of display
        if ( field == 1 )
            x = round(rand*(width-2*margin-xe) + margin+xe/2);
            
        elseif ( field == 2 )
            x = round(rand*(width/2-4*margin-xe) + margin+xe/2) + width/2;
            
        else
            x = round(rand*(width-4*margin-xe) + margin+xe/2);
            
        end
        
        y = round(rand*(height-20*mindist-ye) + 10*mindist+ye/2);
        
        found = true; % Assume optimistically that we found it
        
        for j = round(x-xe/2-mindist) + 1:round(x+xe/2+mindist)
            
            for k = round(y-ye/2-mindist) + 1:round(y+ye/2+mindist)
                
                if im(k,j,3) == 100;
                    
                    found = false; % Oh well, we didn't find it...
                    
                end;
            end;
        end;
    end;
    
    % Paint yellow around the area
    im(round(y-ye/2-mindist)+1:round(y+ye/2+mindist),...
        round(x-xe/2-mindist)+1:round(x+xe/2+mindist),3) = 100;
    
    % Paint the stimuli itself
    im(round(y-ye/2):round(y-ye/2)+ye,...
        round(x-xe/2):round(x-xe/2)+xe,:) = 0;
    
    if list(i)==1 || list(i)==2
        
        im(round(y-ye/2):round(y-ye/2)+ye,...
            round(x-xe/2):round(x-xe/2)+xe,1) = 255;
        
    else
        im(round(y-ye/2):round(y-ye/2)+ye,...
            round(x-xe/2):round(x-xe/2)+xe,2) = darkgreen;
        
    end;
end;

im(find(im==100))=255; % Remove the yellow again

% set a few pixel in the middel to black
x_center = floor(width/2);
y_center = floor(height/2);

% offset = 25;

% im(  y_center-1:y_center+1, (x_center  - offset):( x_center + offset ) ,:) = 0;
% im( (y_center - offset):(y_center + offset), x_center-1:x_center+1 ,:) = 0;

%INCORPORATE DELAY!

% DRAW instructions
% Stimulus kinds are s.t. type 1 = rv, type 2 =  rh,
% type 3 = gv and type 4 = gh

% show the main image;

%image(im);


if ( always_draw_all_stimuli == true )
  %draw objects into im_align_cue and im_color_cue
  im_color_cue = im;
  im_align_cue = im;
end;

stim_width_1 = 600;
stim_width_2 = 60;
stimulus_type

if ( stimulus_type == 1 || stimulus_type == 3 )
  % first objects are vertical - last two objects are horizontal
  xe = stim_width_2; ye = stim_width_1;
  x = xe/2 + 1; y = y_center;
  x2= width-xe/2; y2 = y;
  xe2 = stim_width_1; ye2 = stim_width_2;
  x3 = x_center; y3 = ye2/2 + 1;
  x4 = x3; y4 = height-ye2/2;
elseif ( stimulus_type == 2 || stimulus_type == 4 )
  % first objects are horizontal - last two objects are vertical
  xe = stim_width_1; ye = stim_width_2;
  x = x_center; y = ye/2 + 1;
  x2 = x; y2 = height-ye/2;
  xe2 = stim_width_2; ye2 = stim_width_1;
  x3 = xe2/2 + 1; y3 = y_center;
  x4 = width-xe2/2; y4 = y3;
end;

%draw all objects in color as the color cue
im_color_cue(round(y-ye/2):round(y-ye/2)+ye,...
            round(x-xe/2):round(x-xe/2)+xe,:) = 0;
im_color_cue(round(y2-ye/2):round(y2-ye/2)+ye,...
            round(x2-xe/2):round(x2-xe/2)+xe,:) = 0;
im_color_cue(round(y3-ye2/2):round(y3-ye2/2)+ye2,...
            round(x3-xe2/2):round(x3-xe2/2)+xe2,:) = 0;
im_color_cue(round(y4-ye2/2):round(y4-ye2/2)+ye2,...
            round(x4-xe2/2):round(x4-xe2/2)+xe2,:) = 0;

stim_color_value = 255;
stim_color_index = 1;
if ( stimulus_type == 3 || stimulus_type == 4 )
  stim_color_value = darkgreen;
  stim_color_index = 2;
else
  stim_color_value = 255;
  stim_color_index = 1;
end;

im_color_cue(round(y-ye/2):round(y-ye/2)+ye,...
            round(x-xe/2):round(x-xe/2)+xe,stim_color_index) = stim_color_value;
im_color_cue(round(y2-ye/2):round(y2-ye/2)+ye,...
            round(x2-xe/2):round(x2-xe/2)+xe,stim_color_index) = stim_color_value;
im_color_cue(round(y3-ye2/2):round(y3-ye2/2)+ye2,...
            round(x3-xe2/2):round(x3-xe2/2)+xe2,stim_color_index) = stim_color_value;
im_color_cue(round(y4-ye2/2):round(y4-ye2/2)+ye2,...
            round(x4-xe2/2):round(x4-xe2/2)+xe2,stim_color_index) = stim_color_value;

% the display for the orientation/alignment cue - just picking the first
% two drawn intow the im_color_cue
im_align_cue(round(y-ye/2):round(y-ye/2)+ye,...
            round(x-xe/2):round(x-xe/2)+xe,:) = 100;
im_align_cue(round(y2-ye/2):round(y2-ye/2)+ye,...
            round(x2-xe/2):round(x2-xe/2)+xe,:) = 100;

orient_queue_pause = 1.00;
visual_queue_pause = 0.50;

image(im_align_cue);
axis off
drawnow;
pause(orient_queue_pause);

image(im_color_cue);
axis off
drawnow;
pause(visual_queue_pause);

image(im)
axis off
drawnow;

