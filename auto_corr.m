clear all
clc
close all



n = 5000;
cor = zeros(1,5000);


t = (1:n);
x = zeros(1,n);
y = zeros(1,n);
sigma_w = 1;
sigma_v = 10;


for i= 1:500

for k= 2:n
    x(k) = x(k-1) + normrnd(0,sigma_w);
    y(k) = x(k) + normrnd(0,sigma_v);
end


cor = cor + autocorr(y,4999);

end
plot(cor)