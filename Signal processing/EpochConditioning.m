function [ sig ] = EpochConditioning ( sig )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    sig = double(sig);
    
    sig = (sig - min(sig));
    
    sig = (sig ./ max(sig) * 2) - 1;
end

