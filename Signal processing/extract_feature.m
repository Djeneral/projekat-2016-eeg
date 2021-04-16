function [ X, Y ] = extract_feature( signal, stimulus_code, stimulus_type, window)
%EXTRACT_FEATURE Summary of this function goes here
%   Detailed explanation goes here
    flashing = (stimulus_code ~= 0);
    
    X = [];
    Y = [];
    
    for n=2:length(signal) - window
        
        if flashing(n)==0 && flashing(n-1)==1
            
            X = [X; signal(n-24:n+window-25)] ;
            
            if (stimulus_type(n-1) == 0)
               Y = [Y; -1];
            else
               Y = [Y; +1];
            end
        end
    end
    
end

