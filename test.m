clear all
clc
close all



n = 2000;



p = ones(1,199);
p = hann(199);
p = p(1:99);
p = p./sum(p);
t = (1:n);
x = zeros(1,n);
y = zeros(1,n);
sigma_w = 1;
sigma_v = 10;
m_list = (1:50);


for k= 2:n
%     sigma_w = (2+2*sin(k/100));
    x(k) = x(k-1) + normrnd(0,sigma_w);
    sigma_v = 1+(5+5*sin(k/100));
    y(k) = x(k) + normrnd(0,sigma_v);
end


davar_waterfall = [];
figure(1)
set(gcf, 'Position', get(0,'ScreenSize'))
for k= floor(numel(p)/2)+2*m_list(end):n-floor(numel(p)/2)
    davar = DAVAR(y, m_list, k, p);
    davar_waterfall = [davar_waterfall; davar];
    
    
    
    subplot(2,1,1)
        
        plot(y(1:k+floor(numel(p)/2)), 'LineWidth',1 ,'Color',[.2, .2, .2]);
        hold('on')
        ylim_value = get(gca,'YLim');
        plot((k-floor(numel(p)/2):k+floor(numel(p)/2)), p.*((ylim_value(2)-ylim_value(1))/max(p))+ylim_value(1), 'LineWidth', 3, 'Color', [.2, .8, .2, .5]);
        ax = gca;
        hold(ax, 'off')
        xlabel('Time')
        ylabel('Signal')
%         xline(k, 'Color', [0.2, 0.9, 0.1],'LineWidth', 2 )
        xline(k  - floor(numel(p)/2))
        xline(k  + floor(numel(p)/2))
    subplot(2,1,2)
        loglog(davar, 'LineWidth', 2, 'Color', [.1, .1, .9]) 
        xlabel('Window length')
        ylabel('AVAR')
        xlim([1, m_list(end)])
        ylim([.5, 100])
        grid on
        
    
    
    
    pause(0.001)
end
%%
figure(2)
waterfall(davar_waterfall)
xlabel('Window length')
ylabel('Time')
zlabel('DAVAR')

