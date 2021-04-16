function [ resp ] = extract_response( signal, stimuli, window )
%SIG2RESP Extracts all responses from signal, given stimuli vector
% Signal(i,j):
%               i - Sample idx
%               j - Channel idx
% stimuli(i) :
%               i - Sample idx
%
% window : length of epoch [samples]
    flashing = (stimuli ~= 0);
    
    stimuli_cnt=ones(1,12);

    response_mtx = [];
    
    for n=2:size(signal,1) - window
        if flashing(n)==0 && flashing(n-1)==1
            stimuli_id=stimuli(n-1);
            response_mtx(stimuli_id,stimuli_cnt(stimuli_id),:, :) = signal(n-24:n+window-25, :);
            stimuli_cnt(stimuli_id)=stimuli_cnt(stimuli_id)+1;
        end
    end
    
    resp = response_mtx;
end

