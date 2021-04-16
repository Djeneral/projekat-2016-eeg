run init.m

c_correct = zeros(1,64);
c_wrong = zeros(1, 64);

for rec_idx = 1 : number_of_recordings
    fprintf('Parsing %i-th epoch...\n', rec_idx);
    sig = Signal_T(rec_idx, :, :);
    sig = reshape(sig, size(Signal_T, 2), size(Signal_T, 3));
    
    epoch = extract_response(sig, StimulusCode_T(rec_idx, :), window);
    
    epoch_stim_avg = average_epoch_by_stim(epoch);
    
    epoch_let_avg = average_epoch_by_letter(epoch);
    
    for jj = 1:64
        score = dummy_scorer (epoch_let_avg, jj); % Ch 11 = Cz

        [mx, idx] = max(score);

        %fprintf('Correct: %c, Detected: %c \n', TargetChar(rec_idx), screen(idx));

        if (TargetChar_T(rec_idx) == screen(idx) )
            c_correct(jj) = c_correct(jj) + 1;
        else
            c_wrong(jj) = c_wrong(jj) + 1;
        end
    end
end

results = c_correct*1.0 ./ (c_correct + c_wrong);

topoplotEEG ( results, 'eloc64.txt')
