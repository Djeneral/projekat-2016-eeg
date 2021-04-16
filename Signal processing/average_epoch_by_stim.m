function [ epoch_s ] = average_epoch_by_stim( epoch )
%AVERAGE_EPOCH_BY_STIM Vra?a srednju epohu po stimulusima
    window = size(epoch, 3);
    epoch_s = mean(epoch, 2);
    epoch_s=reshape(epoch_s,12,[],64);
end

