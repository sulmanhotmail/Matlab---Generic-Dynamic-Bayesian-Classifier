%% readFiles read all trajectory files provided the path
% @params:  Path => path of folder where trajectory files are present
%           numberOfFilesToRead =>  how many files from the folder to read
%           clearPreviousData =>    true => if want to clear previous data
%                                   false => if want to keep previous data
% @return:  TRANSITION_P 183x183 =>  number of transitions by +ve trajectories in total
%                                    time of simulation => zone(n-1) x zone(n)
%           TRANSITION_N 183x183 =>  number of transitions by -ve trajectories in total
%                                    time of simulation => zone(n-1) x zone(n)
%           DELTAT_P 183x183x162 =>  number of transitions by +ve trajectories in
%                                    particular time => zone(n-1) x zone(n) x time(quantized)
%           DELTAT_N 183x183x162 =>  number of transitions by -ve trajectories in
%                                    particular time => zone(n-1) x zone(n) x time(quantized)
function [TRANSITION,DELTAT]=readFiles(clearPreviousData)

% %CONST_DATA.mat% =>   QUANTIZATION 162x1 => this contain the ranges of time quantized over 0:6000 stamps
%                       ZONE 183x4 => contains 4 points of rectangle for each zone boundry in x-y plane.
%                       POS_ZONE 12x1 => contains the zone which are
%                       indication for trajectory to be positive.
load('DATA.mat');
if clearPreviousData
    TRANSITION = zeros(K_RANDOM,length(NODES),length(NODES));
    DELTAT = zeros(K_RANDOM,length(NODES),length(NODES),length(QUANTIZATION));
else
    % %VAR_DATA.mat% =>     TRANSITION_P 183x183 =>  number of transitions by +ve trajectories in total
    %                                    time of simulation => zone(n-1) x zone(n)
    %                       TRANSITION_N 183x183 =>  number of transitions by -ve trajectories in total
    %                                    time of simulation => zone(n-1) x zone(n)
    %                       DELTAT_P 183x183x162 =>  number of transitions by +ve trajectories in
    %                                    particular time => zone(n-1) x zone(n) x time(quantized)
    %                       DELTAT_N 183x183x162 =>  number of transitions by -ve trajectories in
    %                                    particular time => zone(n-1) x zone(n) x time(quantized)
    load('VAR_DATA.mat');
end

for a = 1:1:length(DATA)
    % %Zones% gets zones for all Xi and Yi values
    Xi = DATA{1,a}(1,:);
    Yi = DATA{1,a}(2,:);
    TimeStamp = 1:length(DATA{1,a});
    Zones = zoneAllXY(Xi, Yi, NODES);
    
    [changeZoneId, indexChangeZone] = unique(Zones,'stable');
    % %timeChangerPoints% = times when particular trajectory changed zones
    timeChangerPoints = TimeStamp(indexChangeZone);
    % %changeTime% = time particular id spent in particular zone
    changeTime = diff(timeChangerPoints,1);
    
    % %flagPositive% =  flag to check if trajectory to be positive or not
    %                   false => trajectory is -ve
    %                   true => trajectory is +ve
    % flagPositive = checkPositiveTrajectory(POS_ZONE,changeZoneId);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% TODO flagPositive %%%%%%%%%%%%%%%
    flag_random = checkTrajectory(a,DATA);
    [TRANSITION,DELTAT] = populateVarData(TRANSITION,DELTAT,changeZoneId,QUANTIZATION,changeTime,flag_random);
end
save('VAR_DATA.mat','TRANSITION','DELTAT');
end