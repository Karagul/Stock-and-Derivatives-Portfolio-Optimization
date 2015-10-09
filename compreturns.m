function [ Comp ] = compreturns( Prices )
%Compreturns calculates the compounded returns of a time series of prices
Comp=log(Prices(2:end,:))-log(Prices(1:end-1,:));

end

