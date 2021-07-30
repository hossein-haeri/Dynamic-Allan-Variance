clear all
clc
close all


k = (0:100);

for t=100:1000
    y = 1./sqrt(1+k/t);
    plot(k,y)
    hold on
    
    
end