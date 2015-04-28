%% normalizeTRANSITIONAndDELTAT normalize the TRANSITION across rows and DELTAT across time dimension
% @params:  TRANSITION => TRANSITION_P / TRANSITION_N matrix to edit
%           TRANSITION data according to the trajectory
%           DELTAT => DELTATT_P / DELTATT_N matrix to edit the TRANSITION time
%           according to the trajectory
% @return:  TRANSITION_NORM => TRANSITION_P_NORM / TRANSITION_N_NORM matrix
%           that has normalized values of given TRANSITION matrix
%           DELTATT_NORM => DELTATT_P_NORM / DELTATT_N_NORM matrix
%           that has normalized values of given DELTAT matrix
function [ TRANSITION_NORM, DELTAT_NORM ] = normalize( )
load('VAR_DATA.mat');
% normalize across 2nd dimension
TRANSITION_NORM = zeros(size(TRANSITION));
for a=1:1:size(TRANSITION,1)
    for b=1:1:size(TRANSITION,2)
        x = sum(TRANSITION(a,b,1:size(TRANSITION,3)));
        if x~=0
            for c=1:1:size(TRANSITION,3)
                TRANSITION_NORM(a,b,c) = TRANSITION(a,b,c)/x;
            end
        else
            TRANSITION_NORM(a,b,1:size(TRANSITION,3)) = 1/size(TRANSITION,3);
        end
    end
end

clearvars a b c x

% normalize across 3rd dimension
DELTAT_NORM = zeros(size(DELTAT));
for a=1:1:size(DELTAT,1)
    for b=1:1:size(DELTAT,2)
        for c=1:1:size(DELTAT,3)
            x = sum(DELTAT(a,b,c,1:size(DELTAT,4)));
            if x~=0
                for d=1:1:size(DELTAT,4)
                    DELTAT_NORM(a,b,c,d) = DELTAT(a,b,c,d)/x;
                end
            else
                DELTAT_NORM(a,b,c,1:size(DELTAT,4)) = 1/size(DELTAT,4);
            end
        end
    end
end

clearvars a b c d x
save('VAR_DATA.mat');