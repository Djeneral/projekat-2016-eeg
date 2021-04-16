function [ sig ] = SignalConditioningSVM ( Signal, rec_idx, channel, filt )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

        sig_ch = Signal(rec_idx, :, :);

        sig_ch = reshape(sig_ch, size(Signal, 2), size(Signal, 3));
        
        sig = sig_ch(:, channel);

        sig = reshape(sig, 1, []);

        %figure(1)
        %hold on
        5plot(sig)
        sig = filter(filt, sig);
        %plot(sig, 'r');
        
        sig = sig(128:length(sig)); % 128 je pola reda filtra filt   
        %plot(sig, 'k');
        pause;
end

