clear all
clc
close all

n = 1000;
m = 5000;
ACF = zeros(1,51);
for i=1:m
[x, ~] = rsgeng1D(n,1,1,0.1);
ACF = ACF + autocorr(x,50);

% plot(ACF)
% xlim([1,50])
% plot(x)
end
ACF = ACF./m;

plot(ACF)


function [f,x] = rsgeng1D(N,rL,h,cl)
%
% [f,x] = rsgeng1D(N,rL,h,cl) 
%
% generates a 1-dimensional random rough surface f(x) with N surface points. 
% The surface has a Gaussian height distribution function and a Gaussian 
% autocovariance function, where rL is the length of the surface, h is the 
% RMS height and cl is the correlation length.
%
% Input:    N   - number of surface points
%           rL  - length of surface
%           h   - rms height
%           cl  - correlation length
%
% Output:   f   - surface heights
%           x   - surface points
%
% Last updated: 2010-07-26 (David Bergström).  
%

format long;

x = linspace(-rL/2,rL/2,N);

Z = h.*randn(1,N); % uncorrelated Gaussian random rough surface distribution
                     % with mean 0 and standard deviation h

% Gaussian filter
F = exp(-x.^2/(cl^2/2));

% correlation of surface using convolution (faltung), inverse
% Fourier transform and normalizing prefactors
f = sqrt(2/sqrt(pi))*sqrt(rL/N/cl)*ifft(fft(Z).*fft(F));
noise = 0*randn(1,N);
f = f+noise;
end