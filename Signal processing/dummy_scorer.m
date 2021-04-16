function [ score ] = dummy_scorer( epoch_let, channel )
%GET_SCORE_BY_LETTER Summary of this function goes here
%   Detailed explanation goes here
    ep = epoch_let(:, :, channel);
    
    for ii = 1 : size(ep, 1) % Iter all letters (36)
        score(ii) = mean( ep(ii, 78:130) ) -  mean( ep(ii, 140:240) );
    end
    
    dummy_scorer = score;
end

