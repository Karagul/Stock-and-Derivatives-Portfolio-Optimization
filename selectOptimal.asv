function [ Optimal_Allocation, a ] = selectOptimal( Allocations, Market_Scenarios, g, NumPortf, Current_Prices)
%Select Optimal selects the allocation that gives the maximun satisfaction
%   This code is originally created by Attilio Meucci
Store_Satisfaction=[];
for n=1:NumPortf
  Allocation=Allocations(n,:)';
  Objective_Scenario=Market_Scenarios*Allocation;
  Utility=(Objective_Scenario.^g)/g;
  Satisfaction=(g*mean(Utility))^(1/g);
  Store_Satisfaction=[Store_Satisfaction Satisfaction];
end

[a,Optimal_Index]=max(Store_Satisfaction);
Optimal_Allocation=Allocations(Optimal_Index,:).*Current_Prices';
end

