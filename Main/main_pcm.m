tic 
run init.m

c_correct = zeros(1,64);
c_wrong = zeros(1, 64);

X = []; % Epochs
Y = []; % Samples 

rezultati=zeros(64,1);

class_correct = 0;
class_wrong = 0;
decimate_factor = length(channels);

for rec_idx = 1 : number_of_recordings 
    fprintf('Parsing %i-th epoch...\n', rec_idx);
    sig = Signal(rec_idx, :, :);
    sig = reshape(sig, size(Signal, 2), size(Signal, 3));
    
    Xt = [];
    
    [feature, label] = extract_feature( sig, StimulusCode(rec_idx, :), StimulusType(rec_idx, :), window );

    for ch = channels
        sig = Signal(rec_idx, :, :);
        sig = reshape(sig, size(Signal, 2), size(Signal, 3));
        sig = sig(:, ch);
        sig = reshape(sig, 1, 7794);
        
        sig = filter(d,sig);

        [feature, label] = extract_feature( sig, StimulusCode(rec_idx, :), ...
        StimulusType(rec_idx, :), window );
        
        % Decimate damn feature
        feature = feature(:, 1:decimate_factor:240);
        
        Xt = [Xt, feature];
    end
        
    X = [X ; Xt];
    Y = [Y ; label];
end

run blabla;

for ii = 1:size(X,2)
   t = X(:, ii);
   fprintf('Doing PCM for %i\n', ii);
   w(ii) = PCM(t, Y);
end

class_correct = 0;
class_wrong = 0;

for ii = 1 : 100
    fprintf('Deciding on %i-th signal...\n', ii);
    sig = Signal_T(ii, :, :);
    sig = reshape(sig, size(Signal_T, 2), size(Signal_T, 3));
    
    epoch = extract_response(sig, StimulusCode_T(ii, :), window);
 
    epoch_stim = average_epoch_by_stim ( epoch ); 
    
    ep = [];
    
    for ch = channels
        ep = [ep, epoch_stim(:, :, ch) ] ;
    end
    
    for st = 1:12
        ep(st,:)=filter(d,ep(st,:));
        score(st) = sum ( w .* ep(st, :) ); 
    end
    
    [mx, col_id] = max( score(1:6)  );
    [mx, row_id] = max( score(7:12) );
    
    val = (row_id - 1)*6 + col_id;
    
    fprintf('Corect: %c; Detected: %c\n', TargetChar_T(ii), screen(val));
            
    l(ii, 1) = TargetChar_T(ii);
    l(ii, 2) = screen(val);
    
    if (TargetChar_T(ii) == screen(val))
        class_correct = class_correct + 1;
    else
        class_wrong = class_wrong + 1;
    end
end

fprintf('Accuracy: %.2f\n', 100 * ...
    class_correct / (class_wrong + class_correct));

toc
