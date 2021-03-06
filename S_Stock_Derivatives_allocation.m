%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This sript computes optimal allocations of combined stock and derviatives
% Each of the optimal allocations computed corresponds to an gama in the
% gama array that represent different levels of risk aversion. 
% Author: Miel Zozaya Garcia 
% Date: 12 October 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tau/tau(tilda)
horizon = 20;
% option expiry date
v = 10*7/365;
r = 0.05;
J = 10000;
Budget = 1000000;
gamas = [0.9 0.5 -1 -2 -4 -6 -9];
NumPortf = 50;

%Load Data
load TimeSeries2;

%Separate Data
stock_ts = data(:,1:end/2);
iv_ts = data(:,end/2+1:end);
% Get investment decision time values
stock_pt = stock_ts(end,:);
iv_pt = iv_ts(end,:);
% Get options prices at investment decision time
[call_pt,Put] = blsprice(stock_pt, stock_pt, r, v, iv_pt);
Current_Prices = [stock_pt call_pt]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Invariants and their distribution
% Stock Invariants
% Compute compounded returns
comp_returns_t = compreturns(stock_ts);
comp_mean_t = mean(comp_returns_t);
comp_cov_t = cov(comp_returns_t);

% Option Invariants
%  Changes in ATM IV
iv_change_t = change (iv_ts);
civ_mean_t = mean(iv_change_t);
civ_cov_t = cov(iv_change_t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Invariants to the investment horizon
%
comp_mean_hor = comp_mean_t .* horizon;
comp_cov_hor = comp_cov_t .* horizon;

civ_mean_hor = civ_mean_t .* horizon;
civ_cov_hor = civ_cov_t .* horizon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distribution of prices in horizon
% Get mean and variance of the prices in the investment horizon
[ prices_simul, call_simul ] = simulatePrices( comp_mean_hor, comp_cov_hor, civ_mean_hor, civ_cov_hor, J, stock_pt, iv_pt, r, ((v*365)-horizon)/365);
market_mean_hor = mean([ prices_simul, call_simul ]);
market_cov_hor = cov([ prices_simul, call_simul ]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Efficient frontier.
% %% The original author of the function EfficientFrontier is Attilio
% Meucci.
[ExpectedValue,Std_Deviation, Allocations] = ... % frontier in terms of number of shares
    EfficientFrontier(NumPortf, market_cov_hor, market_mean_hor' ,Current_Prices,Budget);
Rel_Allocations=Allocations.*(ones(NumPortf,1)*Current_Prices')/Budget; % frontier in terms of relative weights

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select Optimal Portfolio
%     Simulate Horizon Market Prices
[ prices_simul, call_simul ] = simulatePrices( comp_mean_hor, comp_cov_hor, civ_mean_hor, civ_cov_hor, J, stock_pt, iv_pt, r, ((v*365)-horizon)/365);
Market_Scenarios = [ prices_simul, call_simul ];
Store_Optimal_Allocations = [];
Store_Satisfaction = [];
for i = 1:size(gamas,2)
    [Optimal_Allocation, Satisfaction] = selectOptimal(Allocations, Market_Scenarios, gamas(i), NumPortf, Current_Prices);
    Store_Optimal_Allocations = [Store_Optimal_Allocations; Optimal_Allocation/Budget];
    Store_Satisfaction = [Store_Satisfaction; Satisfaction];
end