function [mean_hat,cov_hat] = kalman_filter(mean, cov, z, sigma_w, sigma_v, dim, m)
z=z';
m = min(m,dim);
u = 0;
A = zeros(dim);
A(2:end,1:end-1) = eye(dim-1);
% A(1, 1:m) = ones(1,m)./m;
A(1, 1) = 1;
% A = A + 0.001;


R = zeros(dim,1);
R(1) = sigma_w;
Q = zeros(1,1);
Q(1) = sigma_v;



B = zeros(dim, 1);
% C = eye(dim);
C = zeros(1, dim);
C(1:m) = ones(1,m)./m;


mean_ = A*mean + B*u;
cov_ = A*cov*A' + R;

cov_
K = cov_* C'*inv(C*cov_*C'+Q);

mean_hat = mean_ + K*(z - C*mean_);
cov_hat = (1 - K*C)*cov_;

end

