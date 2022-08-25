
function[max_info, reach_times, run_times] = RLCode(eps_function_number, reward, gamma)
%% variable initialization
threshold=0.3;
% gamma= 0.9;
lb=[1,2,3,4,5,6,7,8,9,10];
rb=[91,92,93,94,95,96,97,98,99,100];
rewards=zeros(100,4);
reach_times = 0;
max_reward = 0;
run_times = [];
max_info={};
%% eps function
switch eps_function_number
    case 1
        eps_func = @(x) 1./x;
    case 2
        eps_func = @(x) 100./(100 + x);
    case 3
        eps_func = @(x) (1 + log(x)) ./ x;
    case 4
        eps_func = @(x) (1 + 5*log(x)) ./ x;
end

%% learning stage
run=0;
count=0;
while run~=10
    tic;
    s=1;
    trial =1;
    Q=zeros(100,4); %% new state initialization
    while trial<3000
        s=1;
        k=1;
        N=Q;
        epsilon =eps_func(k);
        alpha =epsilon;
            while s~=100 && alpha>0.005 && k<=400
                idx=[1,2,3,4];
                flag=[];
                %% available actions decidiing
                if length(find(s==rb))==1
                    %%%% the robot cant go right
                    flag = [flag,2];
                end
                if mod(s,10)==0
                    %%%% the robot cant go down
                    flag = [flag, 3];
                end
                if mod(s,10)==1
                    %%%% the robot cant go up
                    flag = [flag, 1];
                end
                if length(find(s==lb))==1
                    %%% the robot cant go left
                    flag = [flag,4];
                end
                idx=setdiff(idx,flag); %%% removing the actions which are not applicable to that state
            %% choosing exploration or exploitation
                if numel(unique(N(s,:)))==1 %% if all the state values are same that means the initial scenarios 
                    action=[idx(randperm(length(idx),1))]; %% the robot will explore
                else
                    best_a=find(N(s,:)==max(N(s,:)));
    %                 disp(epsilon);
                    if rand<=(epsilon) %% if this condition satisfies then the robot will explore
                        idx1=setdiff(idx,best_a); %% exclude the best actions or exploited action
                        action=[idx1(randperm(length(idx1),1))]; %% will choose from the remaining actions
                   
                    else %% or robot will exploit
                        action = best_a;
                    end
                end
            %% calculating Q values
                if action==1
                    %%robot will go up subtract -1
                    Q(s,action) = Q(s,action)+alpha*(reward(s,action)+gamma*max(Q(s-1,:))-Q(s,action));
                    s=s-1;
                elseif action==2 %% right add +10
                    Q(s,action) = Q(s,action)+alpha*(reward(s,action)+gamma*max(Q(s+10,:))-Q(s,action));
                    s=s+10;
                elseif action==3%% bottom add +1
                    Q(s,action) = Q(s,action)+alpha*(reward(s,action)+gamma*max(Q(s+1,:))-Q(s,action));
                    s=s+1;
                elseif action==4 %% left subtract -10N(s,action)
                    Q(s,action) = Q(s,action)+alpha*(reward(s,action)+gamma*max(Q(s-10,:))-Q(s,action));
                    s=s-10;
                end
                k=k+1; 
                epsilon = eps_func(k);
                alpha=epsilon;
            end  
    %% convergence check 
    if norm(N-Q) < 0.005 %% convergence check
        disp('Q state has been Converged')
        break
    end
    trial=trial+1;
    end %% trial will end here
toc;  
if s==100
    disp("number of trials = "+string(trial)+" ,run = "+string(run)+" count ="+string(count));
    count=count+1;
    %% optimal policy checking function
    [reach_flag,all_actions,policy_reward,state_list,label,x,y,total_reward, actions] = optimalPolicy(Q,reward,1,100,gamma, run);
    if total_reward > max_reward %% storing the optimal policy return which is the maximum
        max_reward = total_reward;    
        max_info = {x,y,label,all_actions,policy_reward,state_list, actions}; %% storing all the details

    % update reach times
    if reach_flag == true
        run_times = [run_times toc]; %% store the durations of each succesful run
        figure();
        hold on;
        gridplot(run_times, gamma, max_info, run, total_reward);  %% drawing the grid 
        hold off;
    end
    end
    if reach_flag == true
        reach_times = reach_times + 1; %% count the number of times the robot has reached the 100 state with optimal policy
    end
end
run=run+1;
end
end

% Q(1,2) = Q(1,2)+alpha*(reward(1,2)+gamma*max(Q(2,:))-Q(1,2));