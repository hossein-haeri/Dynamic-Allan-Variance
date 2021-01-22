function [davar] = DAVAR(x, m_list, p0, p)
%% coded by Hossein Haeri %%
%% the code estimates the Allan variance of regularly sampled data (can be used as MATLAB's 'allanvar' function which requires signal processing toolbox)

%% FUNCTION INPUTS %%
    % data_x: data values
    % m_list: list of window lengths which AVAR needs to be evaluated at (in units of number of samples)
    % p0: location at which DAVAR needs to be estimated
    % p: window shape (should be normalized, i.e. sum to one)
    
    %% FUNCTION OUTPUTS %%
    % avar: Allan variance of the data evaluated with each window length in tau_list 

% initialze n as number of data points 
n = numel(x);

% initialized avar as an empty list for storing Allan variance values
davar = [];


win_inx = (p0 - floor(numel(p)/2):p0 + floor(numel(p)/2));
% iterate for each window length m
for i=1:numel(m_list)
    m = m_list(i);
    
    % calculate Allan variance accumulatively accross the time
    davar_sum = 0;
    j = 0;
    for k= win_inx(1):win_inx(end)
        j = j+1;
        % use the definition of the Allan variance to calculate it at the time step k and window length m
        davar_sum = davar_sum + p(j)*(mean(x(k-m+1:k))-mean(x(k-2*m+1:k-m)))^2;
    end
    
    % average the accumulated Allan variance values
    davar = [davar davar_sum];
end
davar = 0.5*davar;