function [outputArg1,outputArg2] = plot_real_time(x,y,X_hat_davar,k,p,horizon,m_list,time_scale, davar, n)
            subplot(2,1,1)
                plot(y(1:k), 'LineWidth',0.5 ,'Color',[.6, .2, .2, 0.2]);
                hold('on')
                ylim_value = get(gca,'YLim');
                plot((k-horizon+1:k), p.*((ylim_value(2)-ylim_value(1))/max(p))+ylim_value(1), 'LineWidth', 3, 'Color', [.2, .8, .2, .5]);
                plot(x(1:k), 'LineWidth',1 ,'Color',[.2, .2, .2 .5]);
                plot(X_hat_davar(:,1),X_hat_davar(:,2), 'LineWidth',1 ,'Color',[0.4660, 0.6740, 0.1880]);
                ax = gca;
                hold(ax, 'off')
                xlabel('Time [k]')
                ylabel('Signal')
                xlim([1, n])
                xline(k  - horizon+1)
                xline(k)
                xline(k - time_scale+1,  'Color', [0.8, 0.2, 0.1],'LineWidth', 2 )
            subplot(2,1,2)
                loglog(davar, 'LineWidth', 2, 'Color', [.1, .1, .9]) 
                xlabel('Window length (m)')
                ylabel('AVAR')
                xlim([1, m_list(end)])
                ylim([.5, 100])
                grid on
            pause(0.001)
end

