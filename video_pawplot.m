function [myVideo] = video_pawplot(vid_dir, output_dir, frame_period, stim_frames, LF_dif, RF_dif, LB_dif, RB_dif, angular_v)
v = VideoReader(vid_dir);

nFrames = v.NumFrames;                  % Number of frames
time_frames = (1:nFrames)/v.FrameRate;  % time vector for every frame

myVideo = VideoWriter(output_dir);          % open video file
myVideo.FrameRate = v.FrameRate/8;          % how many times slow motion
open(myVideo)

figure(1)                               
set(gcf,'Position',[10 10 1500 800])        % fix position and size of the figure
sub1=subplot(2,3,1);                        % left front paw
sub2=subplot(2,3,2);                        % video
sub3=subplot(2,3,3);                        % right front paw
sub4=subplot(2,3,4);                        % left back paw
sub5=subplot(2,3,5);                        % body axis (graph/projection)
sub6=subplot(2,3,6);                        % right back paw

for i = frame_period
    B = stim_frames > i-120 & stim_frames < i+50;

    axes(sub1);
    plot(time_frames(1:i),abs(LF_dif(1:i)), 'Color','#7E2F8E')
    if i >120
        xlim([time_frames(i-120) time_frames(i+50)])
    else
        xlim([time_frames(1) time_frames(i+50)])
    end
    if any(B)
        xline(time_frames(stim_frames(B)))
    end
    title('Left front paw')
    xlabel('time (seconds)')
    ylabel('Velocity (pixels/frame)')
    ylim([0 6])
    
    axes(sub2);
    v.CurrentTime = (i+5)/myVideo.FrameRate;       % +5 so the video and other plots run simultaneously
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', sub2);

    sub2.Visible = 'off';
    
    axes(sub3);
    plot(time_frames(1:i),abs(RF_dif(1:i)), 'Color',[0.0196    0.2824    1.0000])
    if i >120
        xlim([time_frames(i-120) time_frames(i+50)])
    else
        xlim([time_frames(1) time_frames(i+50)])
    end
    if any(B)
        xline(time_frames(stim_frames(B)))
    end
    title('Right front paw')
    xlabel('time (seconds)')
    ylabel('Velocity (pixels/frame)')
    ylim([0 6])
%     legend({'Body axis'},'FontSize',7)
    
    axes(sub4);
    plot(time_frames(1:i),abs(LB_dif(1:i)), 'Color',[0.0980    0.4314    0.4314])                    % negative value so it goes up when moving up in the screen
    if any(B)
        xline(time_frames(stim_frames(B)))
    end
    if i >120
        xlim([time_frames(i-120) time_frames(i+50)])
    else
        xlim([time_frames(1) time_frames(i+50)])
    end
    title('Left back paw')
    xlabel('time (seconds)')
    ylabel('velocity (pixels/frame)')
    ylim([0 6])

    axes(sub5);
    plot(time_frames(1:i),angular_v(1:i), 'Color',[0.6588    0.0745    0.0745])
    hold on
    yline(0,'--','Color', 'black');
    if any(B)
        xline(time_frames(stim_frames(B)))
    end
    if i >120
        xlim([time_frames(i-120) time_frames(i+50)])
    else
        xlim([time_frames(1) time_frames(i+50)])
    end
    title('Body axis')
    xlabel('Time (seconds)')
    ylabel('Angular velocity (radians/frame)')
    ylim([-0.03 0.03])
    hold off

    axes(sub6);
    plot(time_frames(1:i),abs(RB_dif(1:i)), 'Color',[0.2039    0.4392    0.3294])                    % negative value so it goes up when moving up in the screen
    if any(B)
        xline(time_frames(stim_frames(B)))
    end
    if i >120
        xlim([time_frames(i-120) time_frames(i+50)])
    else
        xlim([time_frames(1) time_frames(i+50)])
    end
    title('Right back paw')
    xlabel('time (seconds)')
    ylabel('velocity (pixels/frame)')
    ylim([0 6])
    disp(v.CurrentTime)

    sgt  = sgtitle('Mouse movement bottom camera (8x slow motion)');
    sgt.FontSize = 12;
    drawnow
    frame=getframe(gcf);
    pause(0.0001)
    writeVideo(myVideo, frame);
    
end
 
close(myVideo)
end