function [ linear ] = change( TimeSeries )
%Linear Returns computes linear returns of the input time series
linear=TimeSeries(2:end,:)-TimeSeries(1:end-1,:);


end

