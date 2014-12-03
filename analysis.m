% NEED TO REWRITE THIS!

% Load and analyze data
data = dir('subjects/subject*');
r=zeros(2,2,2,length(setsizes),length(data),numblock,2);
for i=1:length(data)
    t=load(['subjects/' data(i).name]);
    t(:,1:numpar)=t(:,1:numpar)+1; % Translate [0 1] into [1 2]
    for j=1:length(t)
        t(j,numpar+1)=find(setsizes==t(j,numpar+1)); % Translate set sizes into order
        b=1;
        searching=true;
        while searching % Find an empty entry in s
            if r(t(j,1),t(j,2),t(j,3),t(j,4),i,b,1)>0
                b=b+1;
            else
                r(t(j,1),t(j,2),t(j,3),t(j,4),i,b,:)=[t(j,numpar+3) t(j,numpar+4)];
                searching=false;
            end
        end
    end
end
% Simple example of how to use this response matrix
r2=r(:,:,:,:,:,:,2);        % Pick the reaction time
r2=permute(r2,[4 1 2 3 5]); % Move the set size element to the front
r2=reshape(r2,2,2*2*2*2);   % Collaps the other dimensions
mean(r2,2)                  % Calculate the mean reaction time for each set size