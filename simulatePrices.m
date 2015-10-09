function [ prices_simul, call_simul ] = simulatePrices( comp_mean_hor, comp_cov_hor, civ_mean_hor, civ_cov_hor, numSimulations, stock_pt, iv_pt, rate, time)
%SimulatePrices Simulates the prices of stocks and call options
%   inv_mean and inv_cov relate to the mean and variance of 
%   the market invariants. It is assumed that the first half corresponds
%   to stock price's compounded returns, that the second half corres-
%   ponds to the change in implied volatility and that they are jointly
%   normally distributed

% Draw the simulations of the multivariate normal random variable
[comp_simul] = mvnrnd(comp_mean_hor,comp_cov_hor,numSimulations);
[civ_simul] = mvnrnd(civ_mean_hor,civ_cov_hor,numSimulations);


% compute stock prices
prices_simul = [];
for i = 1:size(comp_simul,1)
[prices_simul] = [prices_simul;stock_pt .* exp(comp_simul(i,:))];
end

% compute implied volatilities
iv_simul = [];
for i = 1:size(civ_simul,1)
[iv_simul] = [iv_simul;abs(iv_pt + civ_simul(i,:))];
end

stock_pt_mat = repmat(stock_pt,size(prices_simul,1),1);
% compute call prices
[call_simul, put] = blsprice(prices_simul,stock_pt_mat,rate,time,iv_simul);

end

