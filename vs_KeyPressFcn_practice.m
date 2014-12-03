function vs_KeyPressFcn(hObject, eventdata, handles)

global all_responses trial_nr

global width height im im_color_cue im_align_cue
% Object display properties 
global  margin mindist long short 

% Globals for the delay
global visual_queue_pause

% Data recording and program flow
global parameters all_responses trial_nr
global breathe semaphore

% Globals for parameter information
global kinds_of_objects
global speak_orientation_first 
% Globals to access the parameters at their appropriate index
global sti_con_index sti_type_index set_size_index block_index field_index delay_index

reactiontime = toc;
currentkey =  double(get(hObject,'CurrentKey'));
disp('Key is pressed');
right_key = false;
right_response_key = false;
if ( isequal(get(hObject,'CurrentKey'),'1') || isequal(get(hObject,'CurrentKey'),'0') ||...
        isequal(get(hObject,'CurrentKey'),'space'))
	right_key = true;
end
if ( isequal(get(hObject,'CurrentKey'),'1') || isequal(get(hObject,'CurrentKey'),'0') )
    right_response_key = true;
end

if ( semaphore == false && right_key == true )
    semaphore = true; % Prevent new key presses while processing this
    
    if (trial_nr <= length(parameters)) % Are we done yet?
        
        if ( breathe && right_response_key )
            draw_white(); % flash display white
            % DO YOU want the fixation cross to be drawn all the time?
            % draw_fixation_cross();
            disp('Recording data for trial_nr');
            disp(trial_nr);
            all_responses = [all_responses; ...
                parameters(trial_nr,:) currentkey(1) reactiontime];
            trial_nr = trial_nr + 1;
            breathe = false;
            
        elseif ( right_response_key == false && breathe == false )
            draw_fixation_cross();
            pause(1);
            
            % **** Draw Experiment Display
            % reset im to white
            im = uint8(zeros(height,width,3)+255); 
            im_color_cue = uint8(zeros(height,width,3)+255);
            im_align_cue = uint8(zeros(height,width,3)+255);
            % Compute the desired number of objects of each kind
            % number of objects of each kind 
            object_collection = zeros(kinds_of_objects,1);
            remaining_objects = parameters( trial_nr, set_size_index );
            
            % stimulus_type is from 1 to kinds_of_objects
            stimulus_type = parameters( trial_nr, sti_type_index );
            
            if ( parameters( trial_nr, sti_con_index ) )
                object_collection( stimulus_type ) = 1;
                remaining_objects = remaining_objects - 1;
            end
            
            additional_objects = mod(remaining_objects, kinds_of_objects-1);
            remaining_objects  = remaining_objects - additional_objects;
         
            for i = 0:2
               object_type = mod(stimulus_type + i,4) + 1;
               object_collection( object_type ) = remaining_objects / (kinds_of_objects-1) ;
            end
            
            % the last other object_type (other than the stimulus)
            % gets additional objects, depending on whether set_size is
            % divisible by 3
            object_collection( object_type ) = object_collection( object_type ) + additional_objects;
                    
            % FROM_AK: THIS always_draw_all_stimuli NEEDS TO BE SET TO THE VALUE READ FROM PARAMETERS!
            always_draw_all_stimuli = true; %or alternatively = false;
            % always_draw_all_stimuli  = parameters .......

            
            tic
            
            % Present stimulus
            % disp('Showing objects rv rh gv gh');
            create_display(object_collection(1), object_collection(2),...                                                                                            
                object_collection(3),object_collection(4), parameters( trial_nr, field_index ),...
                stimulus_type, always_draw_all_stimuli);
            
            %imp = permute(im,[2 1 3]);  % Turn the image for presentation
            breathe = true;

            %tic
            
        end; % breathe
    else % End the experiment, all trials finished
        quit_practice();
    end;
    semaphore = false; % Allow new keypresses again
end; % semaphore