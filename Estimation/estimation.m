clear all
clc
% close all


realtime_visualization = 1;
num_samples = 1000;
num_monte = 1;
m_list = (1:25);
horizon = 150;


p = ones(1,horizon);
% p = hann(2*horizon);
% p = bartlett(2*horizon);
% p = p(1:horizon/2);

p = p./sum(p);
n = num_samples + 2*m_list(end)+numel(p)-1;

    %%






[x, y] = simulate_signal(n, p, m_list);

if realtime_visualization == 1
    fig = figure(1);
    set(gcf, 'Position', get(0,'ScreenSize'))
    ax = gca;
end





for monte= 1:num_monte
    monte
    
    X_hat_davar = [];
    
    for k= floor(numel(p))+2*m_list(end):n

        [x_hat_davar, davar, time_scale] = avar_based_moving_average(y(k-horizon+1:k), m_list);
        
        X_hat_davar = [X_hat_davar; k x_hat_davar];
        
        if realtime_visualization == 1
            plot_real_time(x,y,X_hat_davar,k,p,horizon,m_list,time_scale, davar, n)
            
        end
    end
    


end




