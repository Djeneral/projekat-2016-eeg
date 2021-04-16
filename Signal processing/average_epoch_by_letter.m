function [ letter ] = average_epoch_by_letter( epoch )
%AVERAGE_EPOCH_BY_LETTER Vra?a srednju epohu po slovima
%   
    window = size(epoch, 3);
    avgresp = average_epoch_by_stim( epoch );
    
    m = 1;
    for row=7:12
        for col=1:6
            % row-column intersection
            letter(m,:,:)=(avgresp(row,:,:)+avgresp(col,:,:))/2;
            m=m+1;
        end
    end
    average_epoch_by_letter = letter;
end

