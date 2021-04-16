run init.m

rezultati=zeros(64,1);

c_correct = zeros(1,64);
c_wrong = zeros(1, 64);

decimate_factor = length(channels); %Decimation factor


for channel=3:3
    channels=channel;
    channel
    class_correct=0;
    class_wrong=0;
    
    X = []; % Epochs
    Y = []; % Samples 
    
for rec_idx = 1 : number_of_recordings 
    %fprintf('Parsing %i-th recording...\n', rec_idx);
    sig = Signal(rec_idx, :, :);
    sig = reshape(sig, size(Signal, 2), size(Signal, 3));
    
    Xt = [];
    
    for ch = channels 
        sig_mono = sig(:, ch);
        sig_mono = reshape(sig_mono, 1, 7794);
    
     %sig_mono = sig_mono - (sig(:,43))';
     
     sig_mono = filter(d,sig_mono);
       
        [feature, label] = extract_feature( sig_mono, StimulusCode(rec_idx, :), ...
        StimulusType(rec_idx, :), window );
        
        feature = feature(:, 1:decimate_factor:window);
    
        Xt = [Xt, feature];
    end
    X = [X ; Xt];
    Y = [Y ; label];
    
end

run blabla.m;

for ii = 1: (length(1:decimate_factor:window) * length(channels))
   t = X(:, ii);
   %fprintf('Doing PCM for %i\n', ii);
   w(ii) = PCM(t, Y);
end

for ii = 1 : 100
    %fprintf('Deciding on %i-th signal...\n', ii);
    sig = Signal_T(ii, :, :);
    sig = reshape(sig, size(Signal_T, 2), size(Signal_T, 3));
    
    epoch = extract_response(sig, StimulusCode_T(ii, :), window);
 
    epoch_stim = average_epoch_by_stim ( epoch );
    % 12 240 64
    
    for st = 1:12
        x = epoch_stim(st, 1:decimate_factor:window, channels); %s
        x = reshape(x, length(1:decimate_factor:window), length(channels)); %s
        x = reshape(x', 1, length(1:decimate_factor:window) * length(channels)); %s
        ep(st, :) = x;
    end
   
    for st = 1:12
        ep(st,:)=filter(d,ep(st,:));
        score(st) =  sum ( w .* ep(st, :) ); 
    end
    
    [mx, col_id] = max( score(1:6)  );
    [mx, row_id] = max( score(7:12) );
    
    val = (row_id - 1)*6 + col_id;
    
    %fprintf('Corect: %c; Detected: %c\n', TargetChar_T(ii), screen(val));
    
    if (TargetChar_T(ii) == screen(val))
        class_correct = class_correct + 1;
    else
        class_wrong = class_wrong + 1;
    end
end

rezultati(channel)=100*(class_correct/(class_correct+class_wrong));

fprintf('Accuracy: %.2f\n', 100 * ...
    class_correct / (class_wrong + class_correct));
end;
