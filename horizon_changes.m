clear all
clc
close all


realtime_visualization = 0;
num_samples = 1000;
num_monte = 10;
m_list = (1:20);

p = ones(1,199);
% p = hann(199);
% p = bartlett(99);

p = p(1:(numel(p)+1)/2+1);
p = p./sum(p);

% s_list = [1 8;
%           1 4;
%           1 8];
      
s_list = [1 2];

mean_time_scale = zeros(3, num_samples);
std_time_scale = zeros(3, num_samples);
mean_min_value = zeros(1, num_samples);
    


% t = (1:n);
n = num_samples + 2*m_list(end)+numel(p)-1;
sigma_w = 1;
% sigma_v = 10;
ref_list = [];


p_list = [99, 199, 399];


for s=1:3  

p = ones(1,p_list(s));
% p = hann(199);
% p = bartlett(99);

p = p(1:(numel(p)+1)/2+1);
p = p./sum(p);    
n = num_samples + 2*m_list(end)+numel(p)-1;

davar_waterfall_mean = zeros(num_samples, numel(m_list));

time_scale_monte = [];
min_value_monte = [];

if realtime_visualization == 1
    figure(1)
    set(gcf, 'Position', get(0,'ScreenSize'))
end


for monte= 1:num_monte
    x = zeros(1,n);
    y = zeros(1,n);
    ref_time_scale = [];
    for k= 2:n
        if k < (n + (2*m_list(end)+numel(p)-1))/2
%             sigma_w = s_list(s,1); 
            sigma_v = 2;  
        else
%             sigma_w = 5; 
%             sigma_v = s_list(s,2);
            sigma_v = 4;
        end
    % sigma_w = (2+2*sin(k/100));
        x(k) = x(k-1) + normrnd(0,sigma_w);
    % sigma_v = 0+(3+3*sin(k/100));
%         ref = sqrt((6*(sigma_v/sigma_w)^2+1)/2);
        ref = round(sqrt((6*(sigma_v/sigma_w)^2+1)/2));
        ref_time_scale = [ref_time_scale ref];
        y(k) = x(k) + normrnd(0,sigma_v);
    end
    time_scale_hist = [];
    min_value_hist = [];
    davar_waterfall = [];
    monte
    for k= floor(numel(p))+2*m_list(end):n

%         davar = DAVAR(y, m_list, k, p);
        win_inx = (k - floor(numel(p))+1:k);
        davar = allanvar(y(win_inx(1):win_inx(end)), m_list)';
        

        [pks, locs] = findpeaks(-davar);            
%         [~, time_scale] = min(davar);
        if isempty(locs)
            [min_value, time_scale] = min(davar);
        else
            time_scale = locs(1);
            min_value = -pks(1);
        end
        
        
        davar_waterfall = [davar_waterfall; davar];
        time_scale_hist = [time_scale_hist time_scale];
        min_value_hist = [min_value_hist min_value];


        if realtime_visualization == 1
            subplot(2,1,1)
                plot(y(1:k), 'LineWidth',0.5 ,'Color',[.6, .2, .2, 0.6]);
                hold('on')
                ylim_value = get(gca,'YLim');
                plot((k-floor(numel(p))+1:k), p.*((ylim_value(2)-ylim_value(1))/max(p))+ylim_value(1), 'LineWidth', 3, 'Color', [.2, .8, .2, .5]);
                plot(x(1:k), 'LineWidth',1 ,'Color',[.2, .2, .2]);
                ax = gca;
                hold(ax, 'off')
                xlabel('Time [k]')
                ylabel('Signal')
                xlim([1, n])
                xline(k  - floor(numel(p)))
                xline(k)
                xline(k - time_scale,  'Color', [0.8, 0.2, 0.1],'LineWidth', 2 )
            subplot(2,1,2)
                loglog(davar, 'LineWidth', 2, 'Color', [.1, .1, .9]) 
                xlabel('Window length (m)')
                ylabel('AVAR')
                xlim([1, m_list(end)])
                ylim([.5, 100])
                grid on
            pause(0.001)
        end
    end
    
    time_scale_monte = [time_scale_monte; time_scale_hist];
    min_value_monte = [min_value_monte; min_value_hist];
    

%     davar_waterfall_mean = davar_waterfall_mean + davar_waterfall;
    mean_time_scale(s,:) = mean(time_scale_monte);
    std_time_scale(s,:) = std(time_scale_monte);
%     mean_min_value(s,:) = mean(min_value_monte);


end
% davar_waterfall_mean = davar_waterfall_mean ./ num_monte;
ref_list = [ref_list; ref_time_scale];


end


%%
close all
color = [0, 0.4470, 0.7410;
      0.8500, 0.3250, 0.0980;
      0.9290, 0.6940, 0.1250;
      0.4660, 0.6740, 0.1880];



figure(3)
    hold on
    for s=1:3 
        avg = mean_time_scale(s,:);
        std = std_time_scale(s,:);
        x = (1:1:size(mean_time_scale,2));
        plot(x, avg, 'LineWidth', 1, 'Color', color(s,:))
        plot(ref_list(s,numel(p)+2*m_list(end)-1:n-1),...
            'LineWidth', 1.5, 'Color', color(s,:)*0.8, 'LineStyle', '--')
        patch([x fliplr(x)], [avg-std fliplr(avg+std)],...
            color(s,:), 'EdgeColor', [1, 1, 1], 'LineWidth', 0.05, 'FaceAlpha',.1, 'EdgeAlpha',.1)
        legend('DAVAR-based', 'Optimal')
        
    end
    ylabel('Window length')
    xlabel('Time')
    % legend('DAVAR', 'Optimal')
    xlim([0, num_samples])
    ylim([0, 1*m_list(end)])
    grid on

    
% figure(2)
%     hold on
%     plot3(mean_time_scale(1,:),(1:num_samples), mean_min_value+.9, 'Color','r', 'LineWidth', 1)
%     waterfall(davar_waterfall_mean)
%     xlabel('Window length')
%     ylabel('Time')
%     zlabel('AVAR')
%     legend('Characteristic timescale')
%     view([1 -1 2])
%     grid on
    
%%
% figure(4)
% 
% [time, win_len] = meshgrid((1:num_samples), m_list);
% surf(win_len, time, davar_waterfall_mean', 'EdgeAlpha', .05);
