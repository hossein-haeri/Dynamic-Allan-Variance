function [x, y] = simulate_signal(n, p, m_list)
x = zeros(1,n);
y = zeros(1,n);
sigma_w = 1;
for k= 2:n
    if k < (n + (2*m_list(end)+numel(p)-1))/4
        sigma_v = 2;  
    else
        sigma_v = 5;
    end
    x(k) = x(k-1) + normrnd(0,sigma_w);
    y(k) = x(k) + normrnd(0,sigma_v);
end

end

