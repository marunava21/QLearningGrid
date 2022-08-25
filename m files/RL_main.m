clc
clear all
ask = input("load new reward function?('no' for default function) ", "s");
switch ask
    case "no"
        load("task1.mat");
        rewards=reward;
    case "yes"
        n=input("is it a function or file(for qavel.mat give 2)? 1 or 2 ");
    switch n
        case 1
            n= str2func(input("function name without bracket, like rewardgeneration: ","s"));
            rewards=n();
        case 2
            load(input("file name(should contain the qevalreward variable name): ","s"));
            rewards = qevalreward;
    end
end
% disp(reward)
k=input("Task 1 or 2? ");
switch(k)
    case 1
        n=input("enter a epsilon function number(1/2/3/4 for task1): ");
        gamma=input("gamma value? ");
        [max_info, reach_times, run_times] = RL_task1(n, rewards, gamma); %% task1 main function
    case 2
        n=input("enter a epsilon function number(1/2/3/4/5/6 for task2): ");
        gamma=input("gamma value? ");%%% task2 contains 6 functions, task1 functions + epsilon + new defined function
        [max_info, reach_times, run_times] = RL_task2(n, rewards, gamma); %% task2 main function
end
if size(max_info,2)~=0
csvwrite("actions.txt",max_info{1,4}');
csvwrite("paths.txt",max_info{1,6});
csvwrite("optimalactions.txt",max_info{1,7});
end

%% Epsilon Function Plot Generation
k=[];
for i=1:500
    k=[k,i];
end
figure();
hold on;
plot(k, funcgen(1,k), DisplayName="1/x");
hold on;
plot(k, funcgen(2,k), DisplayName="100/(100+x)");
hold on;
plot(k, funcgen(3,k), DisplayName="(1 + log(x))/x");
hold on;
plot(k, funcgen(4,k), DisplayName="(1 + 5*log(x))/x");
hold on;
plot(k, funcgen(5,k), DisplayName="(exp(-0.001*x))");
hold on;
plot(k, funcgen(6,k), DisplayName="((1./x)+((1 + log(x)) ./ x)+0.5)");
hold on;
legend;
hold off;

%%epsilon function generator
function[eps_func]=funcgen(n,k)
switch n
    case 1
        eps_func = @(x) 1./x;
    case 2
        eps_func = @(x) 100./(100 + x);
    case 3
        eps_func = @(x) (1 + log(x)) ./ x;
    case 4
        eps_func = @(x) (1 + 5*log(x)) ./ x;
    case 5
        eps_func = @(x) (exp(-0.001*x));
    case 6
        eps_func = @(x) ((1./x)+((1 + log(x)) ./ x)+0.5);
end
eps_func=eps_func(k);
end