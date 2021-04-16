tic 
run init.m

if (1==1)

X = []; % Epochs
Y = []; % Samples 


rezultati=zeros(64,1);

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

clear Signal Flashing StimulusCode StimulusType

run svm_conditioning.m;

options.MaxIter = 1e6;
s = svmtrain( X, Y, 'options', options, ...
    'kernel_function', 'linear', 'method', 'SMO', 'boxconstraint', 1);        

end

class_correct = 0;
class_wrong = 0;

ss = [];

for ii = 1 : 100
    
    fprintf('Parsing %i-th epoch...\n', ii);
    
    sig = Signal_T(ii, :, :);
    sig = reshape(sig, size(Signal_T, 2), size(Signal_T, 3));
    
    epoch = extract_response(sig, StimulusCode_T(ii, :), window);
    epoch = average_epoch_by_letter(epoch);
    epoch = epoch(:, :, channels);    

    let_id = find(screen == TargetChar_T(ii));
    col_id = mod(let_id, 6);
    row_id = (let_id - col_id)/6 + 1;
    StimulusType_T = StimulusCode_T == col_id | StimulusCode_T == row_id;
    
    score = zeros(1,36);
    
    for jj = 1 : size(epoch, 1) % Id po slovima
        tst = epoch(jj, :);
        tst = filter(d, tst);
        
        score(jj) = svmclassify(s, tst);
    end
     
    ss = [ss; score];
    
    continue

    ep = [];
    
    for ch = channels
        ep = [ep, epoch_stim(:, :, ch) ] ;
    end
    
    for st = 1:12
        ep(st,:)=filter(d,ep(st,:));
    end
    
    score = svmclassify(s, ep);
    
    ss = [ss; score']
    
    continue
            
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


cetri(:,:,:,1) tri(:,:,:)