function [x_hat, davar, time_scale] = avar_based_moving_average(y, m_list)

davar = allanvar(y, m_list)';

[~, locs] = findpeaks(-davar);            

if isempty(locs)
    [~, time_scale] = min(davar);
else
    time_scale = locs(1);
end


x_hat = mean(y(end-time_scale+1:end));


% p = hann(2*time_scale);
% p = p(1:time_scale);
% p = p./sum(p);
% 
% x_hat = dot(y(end-time_scale+1:end),p);




end

