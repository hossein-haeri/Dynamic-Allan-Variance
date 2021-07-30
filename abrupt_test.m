clear all
clc
close all

n = 10000;
x = zeros(n,1);
x(1) = rand();

for i=2:n
    if rand() < 0
        x(i) = rand();
    else
        x(i) = x(i-1) + normrnd(0,1);
    end
end


% plot(x)

ACF = autocorr(x,50);
plot(ACF)
xlim([1,50])