function [flag,all_actions,p_r,states,labels,x,y,t_r, actions] = optimalPolicy(Q,reward,s_state,e_state,d_r, run)
    [~,all_actions]=max(Q,[],2); %% all the normal policies
    s = s_state;
    step = 1;
    t_r = 0;
    x = [];
    y = [];
    labels = [];
    actions=[];
    p_r = zeros(10,10);
    states = [];
    reached=false;
    a=s-fix(s/10)*10;%% grid state x position
    b=fix(s/10)+1; %% grid state y position
    while s~=e_state && step<=100 %% will check if s==100 or step>100
        states = [states s]; %% optimal path
        switch all_actions(s)
            case 1
                actions=[actions, 1]; %% store the actions that will help the robot to reach s=100
                p_r(a,b) = d_r.^(step-1)*reward(s,1); %% reward correspond to optimal path
                s=s-1;
            case 2
                actions=[actions, 2];
                p_r(a,b) = d_r.^(step-1)*reward(s,2);
                s=s+10;
            case 3
                actions=[actions, 3];
                p_r(a,b) = d_r.^(step-1)*reward(s,3);
                s=s+1;
            case 4
                actions=[actions, 4];
                p_r(a,b) = d_r.^(step-1)*reward(s,4);
                s=s-10;
        end
        step = step + 1;
        if mod(s,10)==0
            a=10;
            b=fix(s/10);
        else
            a=s-fix(s/10)*10;
            b=fix(s/10)+1;
        end
    end
    temp_s=s_state;
    a=temp_s-fix(temp_s/10)*10;
    b=fix(temp_s/10)+1;
    %% x and y position of the grid and the corresponding labels
    while temp_s~=e_state 
        x = [x,b-1 + 0.5];
        y = [y,a - 0.5];
%         disp(num2str(x(temp_s))+" "+num2str(y(temp_s)));
        if any(states==temp_s)==1
            switch all_actions(temp_s)
                case 1
                    labels = [labels,'g^'];
                case 2
                    labels = [labels,'g>'];
                case 3
                    labels = [labels,'gv'];
                case 4
                    labels = [labels,'g<'];
            end
        else 
            switch all_actions(temp_s)
                case 1
                    labels = [labels,'r^'];
                case 2
                    labels = [labels,'r>'];
                case 3
                    labels = [labels,'rv'];
                case 4
                    labels = [labels,'r<'];
            end
        end
        temp_s=temp_s+1;
        if mod(temp_s,10)==0
            a=10;
            b=fix(temp_s/10);
        else
            a=temp_s-fix(temp_s/10)*10;
            b=fix(temp_s/10)+1;
        end
        
    end
    if s == 100
        states = [states s];
        x = [x,9.5];
        y = [y,9.5]; 
        labels = [labels,'pg'];
        flag = true;
        disp(['run= '+ string(run)+' has reached with optimal policy'])
    else
        flag = false;
        disp(['run= '+string(run)+' could not reached with optimal policy'])
    end
    t_r = sum(p_r,'all');
end