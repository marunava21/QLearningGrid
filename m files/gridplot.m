function [] = gridplot(run_times, gamma, max_info, run, total_reward)
execution_time=mean(run_times);
axis([0 10 0 10]);grid on;
set(gca,'YDir','reverse');hold on;
title({['\gamma = ',num2str(gamma),' , run = ',num2str(run),' , Avg.exc.time = ',num2str(execution_time),' total reward = ',num2str(total_reward)]});
x = max_info{1,1};
y = max_info{1,2};
label = max_info{1,3};
for i = 1:length(max_info{1,1})
    scatter(x(i),y(i),40,label(i*2-1),label(i*2));
end
end