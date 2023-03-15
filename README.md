%% BEP-thesis

% This folder contains a part of the code that I used for the analysis of my Bachelor End Project. I included the useful code, and left out some that are too specific, too general or only used for figures.

% The important comments are in the code itself, but here are the general descriptions:     
% - change_axis outputs vectors with the direction of movements of all tracked body parts relative to the direction of the body axis. As an input it takes vectors of all x- and y-coordinates of all tracked body parts.

% - select_period outputs a structure with a matrix per ROI where the mouse moves. Every matrix is a 5xN matrix, where N is the amount of frames in this ROI. The columns consist of the frame number and the velocities of the left front paw, right front paw, left back paw and right back paw respectively. As an input it takes the absolute velocities of all paws and a vector with the time of each frame.

% - smooth_test outputs the smoothened total displacement, the smoothened x-coordinates and the smoothened y-coordinates. As an input it takes the original vectors of these.

% - video_pawplot outputs the video with 6 panels: left top is the absolute velocity of the left front paw, middle top is the video, right top is the absolute velocity of the right front paw, left bottom is the absolute velocity of the left back paw, middle bottom is the angular velocity of the body axis and right bottom is the absolute velocity of the right back paw. As an input it takes the input video that goes on top, the output file where the video is stored, the frames that will go in the video, the frames where the stimulus takes place, a vector of the absolute velocities of the paws and a vector of the angular velocity.
