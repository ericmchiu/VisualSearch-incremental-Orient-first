% Code for conducting Linguistic Visual Search experiments

% A table of stimuli is prepared, and for each execution of the function
% vs_KeyPressFcn a response table is prepared and by the end of the
% experiment this table is written to a file with the prefix "subject"

% Use any key to get the next stimuli and 0 and 1 to indicate absence and
% presence

% Display related information
global width height
global vs_figure
% Object display properties 
global  margin mindist long short 

% Globals for the sound
global samplingrate file delays

% Data recording & program flow
global parameters all_responses trial_nr
global breathe semaphore

% Globals for parameter information
global kinds_of_objects
global speak_orientation_first 
% Globals to access the parameters at their appropriate index
global sti_con_index sti_type_index set_size_index block_index field_index delay_index draw_index

% CONDITIONS SETUP
%**************************
% FIXED CONDITIONS
speak_orientation_first = false;
samplingrate = 22050;
% delay = 0           ; % additional delay in seconds between sound and object display

% Variable CONDITIONS (AKA parameters)
% Stimulus object can be present or absent
stimulus_conditions = 2; % present or absent

% Object can one of four kinds
kinds_of_objects = 4; % kind 1,2,3 and 4;

% Once the stimulus is one kinds, the noise is one out of the OTHER kinds
% Total number of objects can be one of 2,3 or 4 sizes
setsizes = [5 10 15 20]; % Set sizes

% CONDITIONS COMPUTED AUTOMATICALLY
number_of_set_sizes = size(setsizes,2);

% How many blocks should the experiment run for?
% Each block contains every conditions exactly once, in random order
% // to get different conditions across blocks add it later
% and increase number_of_blocks here
number_of_blocks = 2;                         

number_of_fields = 1;

number_of_delays = 1;
delays = [0];

% number_of_draw_all_stimuli = 1;
% draw_all_stimuli = [0];

% One parameter for stimulus condition, one for kind of stimulus, one for
% kind of noise, one for setsize; in the order as defined above
% fifth parameter is the block number + increase this if you add parameters
num_parameters = 7;

% These variables determine the index a parameter gets inside 'parameters'
sti_con_index = 1;
sti_type_index = 2;
set_size_index = 3;
block_index = 4;
field_index = 5;
delay_index = 6;
draw_index = 7;

%**************************

% number of conditions determines the number of rows in 'parameters'.
number_of_conditions = ...
    stimulus_conditions * ...
    kinds_of_objects * ...
    number_of_set_sizes * ...
    number_of_blocks * ...
    number_of_fields * number_of_delays; % 2 conditions for left/right field 2 conditions for two delays;

parameters = zeros(number_of_conditions, num_parameters);
for i = 1:number_of_conditions
   parameters(i, sti_con_index )    = mod(i, stimulus_conditions );
   parameters(i, sti_type_index )   = 1 + mod( floor( (i-1) / stimulus_conditions ) ,kinds_of_objects);
   parameters(i, set_size_index )   = 1 + mod( floor( (i-1) / (stimulus_conditions*kinds_of_objects)), number_of_set_sizes);
   parameters(i, block_index )      = 1 + mod( floor( (i-1) / (stimulus_conditions*kinds_of_objects*number_of_set_sizes)), number_of_blocks);
   parameters(i, field_index )      = 1 + mod( floor( (i-1) / (stimulus_conditions*kinds_of_objects*number_of_set_sizes*number_of_blocks)), number_of_fields);
   parameters(i, delay_index )      = 1 + mod( floor( (i-1) / (stimulus_conditions*kinds_of_objects*number_of_set_sizes*number_of_blocks*number_of_fields)), number_of_delays);
   parameters(i, draw_index )       = 1 + mod( floor( (i-1) / (stimulus_conditions*kinds_of_objects*number_of_set_sizes*number_of_blocks*number_of_fields*delay_index)), number_of_draw_all_stimuli);
   % translate the integer 0-1-2-3 ... to actual sizes!
   parameters(i, set_size_index) = setsizes( parameters( i, set_size_index ));
   parameters(i, delay_index)    = delays( parameters( i, delay_index ));
   % parameters(i, draw_index ) = draw_all_stimuli( parameters( i, draw_index ));
end

% RANDOMIZATION OF CONDITIONS
% this randomly permutes the conditions within each block
% NOT across blocks
block_size = number_of_conditions / number_of_blocks;
for i = 0:(number_of_blocks-1)
    from = 1 + i * block_size;
    to = (i+1) * block_size;
    parameters( from - 1 + randperm(block_size),: ) = parameters(from:to,:);
end
% RANDOMIZATION END

% FROM_AK: ADD ACROSS BLOCK CONDITIONS HERE!
% FROM_AK: REPLICATE BLOCKS AND ADD ONE COLUMN WITH THE PROPER CONDITION,
% e.g. the following replicates the same conditions 
% and sets the last column to 1 for the first replicated part and 0 for the
% second

%param_length = size(parameters,1);
%parameters ...
% = [parameters ones(param_length,1);... 
%    parameters zeros(param_length,1)];


% Gather display information
screensize  = get(0,'ScreenSize');          % Get the screen size
width       = screensize(3);                % Width of display
height      = screensize(4)-20;             % Height of display minus something for the handle

margin      =  100;                         % Minimal distance of elemenent from sides
mindist     =  10;                          % Minimal distance between elements
long        =  80;                          % Long side of element
short       =  20;                          % Short side of element

%Loading sound files
files = dir('sound/*.wav');                 % Read the sound files
for i=1:length(files)
    file{i} = wavread(['sound/' files(i).name]);
end

% Initialize variables
disp('Initialize variables');
semaphore       = false;                        % Only process one keypress at a time
breathe         = false;                        % Subject is either active or breathing
all_responses   = [];                           % Table to record all responses in
trial_nr        = 1;                            % index to count trials

% Creates a figure (i.e. a display) associates the vs_KeyPressFcn
% this function is executed every time the user hits a key
disp('Calling figure');
vs_figure = figure(...
    'Position',[0 0 width height],...
    'outerposition',[0 0 width height],...
    'KeyPressFcn',@vs_KeyPressFcn_practice_0,...
    'NumberTitle','off', ...
    'MenuBar','none',...
    'ToolBar','none');  

axis off
axes('position',[0  0  1  1])
text(0.05,.9,'You are about to start a practice block.','Fontsize', 60)
text(0.1,.775,'INSTRUCTIONS: (please read carefully)','Fontsize',40)
text(0.1,.7,'Horizontal bars that appear on the top and bottom of the screen identify a horizontal target.','Fontsize', 30)
text(0.1,.65,'Vertical bars that appear on the left and right of the screen identify a vertical target.','Fontsize', 30)
text(0.1,.6,'The color of the bars identify the color of the target.','Fontsize', 30)
text(0.15,.5,'REMINDER:   vertical -> |   &   horizontal ->','Fontsize', 40)
text(.82,.53,'_','Fontsize', 50)
text(0.1,.4,'If the object is absent press "no" and if the object is present press "yes."','Fontsize', 30)
text(0.1,.35,'After each trial, press the "space bar" to continue.','Fontsize', 30)
text(0.1,.3,'When you are ready, press the "space bar" to begin.','Fontsize', 30)
text(0.05,.2,'Please respond as quickly and accurately as possible.','Fontsize', 50)
text(0.05,.1,'Notify the experimenter when the practice block ends.','Fontsize', 50)
tic
