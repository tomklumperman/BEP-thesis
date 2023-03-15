function [LFdir,RFdir,LBdir,RBdir,nosedir,taildir] = change_axis(LFx,LBx,LFy,LBy,RFx,RBx,RFy,RBy,nosex,nosey,tailx,taily)
%% get the angle of movement compared to the body axis
% calculate all vectors
LFLBx = LFx-LBx;
LFLBy = LFy-LBy;
RFRBx = RFx-RBx;
RFRBy = RFy-RBy;
body_dir_x = nosex - tailx;                 % body dir is a vector
body_dir_y = nosey - taily;                 
[thetaL,~] = cart2pol(LFLBx,LFLBy);
[thetaR,~] = cart2pol(RFRBx,RFRBy);
[thetaM,~] = cart2pol(body_dir_x,body_dir_y);
diffLM = thetaL-thetaM;
diffRM = thetaR-thetaM;
v_LF_x = diff(LFx);
v_LF_y = diff(LFy);
v_RF_x = diff(RFx);
v_RF_y = diff(RFy);
v_LB_x = diff(LBx);
v_LB_y = diff(LBy);
v_RB_x = diff(RBx);
v_RB_y = diff(RBy);
v_nose_x = diff(nosex);
v_nose_y = diff(nosey);
v_tail_x = diff(tailx);
v_tail_y = diff(taily);
[LF_ang,~] = cart2pol(v_LF_x,v_LF_y);  
[RF_ang,~] = cart2pol(v_RF_x,v_RF_y);
[LB_ang,~] = cart2pol(v_LB_x,v_LB_y);
[RB_ang,~] = cart2pol(v_RB_x,v_RB_y);
[nose_ang,~] = cart2pol(v_nose_x,v_nose_y);  
[tail_ang,~] = cart2pol(v_tail_x,v_tail_y);

% calculate the direction of the body axis
theta_body = [];
for i=1:length(thetaL)
    if (diffLM(i)>0.3 && diffLM(i)<5.84)|| (diffLM(i)<-0.3&&diffLM(i)>-5.84)      % if the difference between left paws direction (alignment) and nose-tail direction is too big
        if (diffRM(i)>0.3 && diffRM(i)<5.84)|| (diffRM(i)<-0.3&&diffRM(i)>-5.84)  % if this difference is also with right side
            theta_body(i) = thetaM(i);                                          % only use the nose-tail direction
        else
            theta_body(i) = (thetaM(i)+thetaR(i))/2;                            % only left side difference too big --> use nose-tail and right side 
        end
    elseif (diffRM(i)>0.3 && diffRM(i)<5.84)|| (diffRM(i)<-0.3&&diffRM(i)>-5.84)  % if right side difference is too big
        theta_body(i) = (thetaM(i)+thetaL(i))/2;                                % use middle and left direction        
    else
        theta_body(i) = (thetaM(i)+thetaR(i)+thetaL(i))/3;                      % otherwise combine the three directions
    end
end

% get every movement direction relative to the body axis
body_angle = movmean(theta_body,10);                         % to decrease fluctuations of the body axis
LFdir = angdiff(body_angle(1:length(LF_ang)).',LF_ang);
LBdir = angdiff(body_angle(1:length(LF_ang)).',LB_ang);
RFdir = angdiff(body_angle(1:length(LF_ang)).',RF_ang);
RBdir = angdiff(body_angle(1:length(LF_ang)).',RB_ang);
nosedir = angdiff(body_angle(1:length(LF_ang)).',nose_ang);
taildir = angdiff(body_angle(1:length(LF_ang)).',tail_ang);
%clear LF LB RB LB sm_RBx sm_RBy sm_LBx sm_LBy sm_RFx sm_RFy sm_LFx sm_LFy
%clear thetaL thetaR thetaM LFLBx LFLBy RFRBx RFRBy diffLM LF_ang LB_ang RB_ang RF_ang nose_ang tail_ang
end