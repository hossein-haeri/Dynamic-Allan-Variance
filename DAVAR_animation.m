clear all
clc
close all



n = 5000;

H = 200;
order = 20;
p = ones(1,H);
% p = hann(299);
% p = bartlett(199);


p = p(1:(numel(p)+1)/2+1);
p = p./sum(p);
t = (1:n);
x = zeros(1,n);
y = zeros(1,n);
sigma_w = 1;
sigma_v = 10;
m_list = (1:H/2);


for k= 2:n
   sigma_w = 1;
   sigma_v = 5;
%     x(k) = 2+2*sin(k/50)+10*sin(k/200); % FOR DETERMINISTIC SIGNALS
%     x(k) = x(k-1) + normrnd(0,sigma_w); % FOR RANDOM WALK
    
    % Build peacewise 
    if k > n/5
        x(k) = 2+2*sin(k/50)+10*sin(k/200);
    else
        x(k) = 2+10*sin(k/10)+10*sin(k/200);
    end
    
    % Add white noise
    y(k) = x(k) + normrnd(0,sigma_v);
end





time_scale_hist = [];
davar_waterfall = [];
figure(1)
set(gcf, 'Position', get(0,'ScreenSize'))

% x_hat = zeros(order,1);
x_hat = zeros(order,1);
cov_hat = eye(order);
est = [];
k0 = floor(numel(p))+2*m_list(end);
for k= k0:n
    davar = DAVAR(y, m_list, k, p);
    
    % look for global minimum
%     [~, time_scale] = min(davar);
    % look for the first minimum
    time_scale = (find(diff(davar)>0,1,'first'));

    davar_waterfall = [davar_waterfall; davar];

    time_scale_hist = [time_scale_hist time_scale];

    if k > n/2
        sigma_v = 10;
    else
        sigma_v = 2;
    end

%     [x_hat, cov_hat] = kalman_filter(x_hat, cov_hat, y(k-order+1:k), sigma_w, sigma_v, order, time_scale);
%     [x_hat, cov_hat] = kalman_filter(x_hat, cov_hat, y(k), sigma_w, sigma_v, order, time_scale);
%     x_hat(1)
%     est = [est; k, x_hat(1), cov_hat(1)];
    
    subplot(3,1,1)
        % plot measurements
        plot(y(1:k), 'LineWidth',0.5 ,'Color',[.6, .2, .2, 0.4]);
        hold('on')
        ylim_value = get(gca,'YLim');
        % plot window
        plot((k-floor(numel(p))+1:k), p.*((ylim_value(2)-ylim_value(1))/max(p))+ylim_value(1), 'LineWidth', 3, 'Color', [.2, .8, .2, .5]);
        % plot the true signal
        plot(x(1:k), 'LineWidth',1 ,'Color',[.2, .2, .2]);
        % plot kalman filtered signal
%         plot(est(:,1), est(:,2), 'LineWidth',1 ,'Color',[.2, .2, .8])
        ax = gca;
        hold(ax, 'off')
        xlabel('Time [k]')
        ylabel('Signal')
        xlim([1, n])
        xline(k  - floor(numel(p)))
        xline(k)
        xline(k - time_scale,  'Color', [0.8, 0.2, 0.1],'LineWidth', 2 )
    subplot(3,1,2)
        loglog(davar, 'LineWidth', 2, 'Color', [.1, .1, .9]) 
        xlabel('Window length (m)')
        ylabel('AVAR')
        xlim([1, m_list(end)])
        ylim([.5, 100])
        grid on
    subplot(3,1,3)
        plot((k0:numel(time_scale_hist)+k0-1),time_scale_hist, 'LineWidth', 2, 'Color', [.1, .1, .9]) 
        xlabel('Time [k]')
        ylabel('Window length (m)')
        xlim([1, n])
        ylim([1, m_list(end)])
        grid on
    pause(0.001) 
end



%%
% figure(2)
% waterfall(davar_waterfall)
% xlabel('Window length')
% ylabel('Time')
% zlabel('DAVAR')
% 
% figure(3)
% plot(time_scale_hist)
% xlabel('Window length')
% ylabel('Time')
% zlabel('DAVAR')