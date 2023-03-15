function [per, rois] = select_period(LF_dif,RF_dif,LB_dif,RB_dif,time_frames,video_time)
% output:
% per = struct with nx5 matrices, with in every row the frame, and velocities
% of LF, RF, LB, RB for every frame in the ROIs. 1 matrix for every ROI
% rois = every frame that is in the ROIs
%% look for periods where mouse is walking
%## are numbers that can be changed (thresholds for example)
fps = length(time_frames)/video_time;                 % frames per second
frame_th = round(0.03*fps);     %##                   % threshold amount of frames (step is at least ~0.1 second)
rois = [];                                            % vector where all frames of interest will be stored
vTH = 0.6;                      %##                   % threshold for velocity to exceed (generally back paws move less than front paws)

for i = round(0.1*fps):length(LF_dif)+1-frame_th*2          % go over all frames, starting from 10 because the roi starts 10 frames before movement
    n = i;
    AA = abs(LF_dif(n))>vTH;
    BB = abs(RF_dif(n))>vTH;
    CC = abs(LB_dif(n))>vTH;
    DD = abs(RB_dif(n))>vTH;
    if AA || BB || CC || DD                           % threshold for velocity (different for front and back paws)
        vLF_oi = abs(LF_dif(i:i+frame_th*2));   %##   % velocity of interest - take a window from i up to 2x frame threshold 
        vRF_oi = abs(RF_dif(i:i+frame_th*2));   %##
        vLB_oi = abs(LB_dif(i:i+frame_th*2));   %##
        vRB_oi = abs(RB_dif(i:i+frame_th*2));   %##
        LFabove_th = find(vLF_oi > vTH);              % check how many frames of this window the velocity is above threshold
        RFabove_th = find(vRF_oi > vTH);
        LBabove_th = find(vLB_oi > vTH);
        RBabove_th = find(vRB_oi > vTH);
        aa=length(LFabove_th)>frame_th; bb=length(RFabove_th)>frame_th; cc=length(LBabove_th)>frame_th; dd=length(LBabove_th)>frame_th; % true or false above threshold
        if nnz([aa bb cc dd]) > 0               %##   % if at least two of the paws satisfy thresholds
            while nnz([AA BB CC DD]) > 0              % while the one of the paws exceed velocity TH
                if isempty(rois)
                    rois = [rois,n-10:n+8];     %##   % add all numbers of indices that should be plotted (100ms before start movement and 700ms after start)
                elseif n > rois(end)+10               % check that the numbers in the rois will not overlap
                    if rois(end) + 50 > n       %##   % if the difference between last and new index is smaller than 100 frames
                        rois = [rois,rois(end)+1:n+8];   %##        % add those inbetween as well
                    else    
                        rois = [rois,n-10:n+8];          %##        % add all numbers of indices that should be plotted
                    end
                end
                n = n+1;
                AA = abs(LF_dif(n))>vTH;            % check next values if it exceeds threshold
                BB = abs(RF_dif(n))>vTH;
                CC = abs(LB_dif(n))>vTH;
                DD = abs(RB_dif(n))>vTH;
            end
        end
    end
end

%% extract values for these roi
prev = rois(1)-1;                                % condition to start writing, they cannot overlap
count = 1;
per = struct;                                    % create structure to store values within rois
for i = 1:length(rois)                           % go over all roi frames, to split in seperate groups
    if rois(i) ~= prev+1                         % if this frame is not adjecent to the previous,
        count = count + 1;                       % next roi
    end
    prev = rois(i);                              % store previous value to check
end

n = 1;
prev = rois(1)-1;
per.rois = cell(1,count);
for ii = 1:length(rois)
    LF_write = abs(LF_dif(rois(ii)));            % data to put in to struct field
    RF_write = abs(RF_dif(rois(ii)));
    LB_write = abs(LB_dif(rois(ii)));
    RB_write = abs(RB_dif(rois(ii)));
    if rois(ii) ~= prev+1                        % if this frame is not adjecent to previous frame,
        n = n + 1;                               % next roi
    end
    
    per.rois{1,n} = [[per.rois{1,n}];time_frames(rois(ii)),LF_write, RF_write, LB_write, RB_write];  % write frame number, and velocity data of paws
    prev = rois(ii);
end

%% if an roi is too small, delete this
not_done = true;
i = 1;
while i <= length(per.rois)                           % loop over number of fields
    if length(per.rois{1,i}) < 40                 %## % if the roi is too small (can be changed to other number or roi's too large)
        for fi = 1:length(per.rois{1,i})              % loop over indices of the field
            rois = rois(rois~=per.rois{1,i}(fi));     % remove from the rois vector
        end
        per.rois(i) = [];                             % remove from cell
    else
        i = i+1;
    end
end
%% plot movement of rois
for i = 20:30
    figure,
    plot(per.rois{1,i}(:,1), per.rois{1,i}(:,2:end))
    legend({'left front','right front','left back','right back'})
    %saveas(gcf, 'Z:\Users\Tom\FM-Data-for-Tom\Saved-figures\cross_correlation\220706-004_period_roi6')
end

% clear vRF_oi vLF_oi vLB_oi vRB_oi LFabove_th RFabove_th LBabove_th RBabove_th AA BB CC DD LB_write LF_write RF_write RB_write aa bb cc dd
end