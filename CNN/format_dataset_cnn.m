%run init.m; 

X = []; % Epochs
Y = []; % Samples 

decimate_factor = length(channels);

number_of_recordings = 85;

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

run blabla.m;

train_x = X;
train_y = Y;
       
X = [];
Y = [];

for ii = 1 : 100
    fprintf('Parsing %i-th epoch...\n', ii);
    
    let_id = find(screen == TargetChar_T(ii));
    col_id = mod(let_id, 6);
    row_id = (let_id - col_id)/6 + 1;
    StimulusType_T = StimulusCode_T == col_id | StimulusCode_T == row_id;
    
    [feature, label] = extract_feature( sig, StimulusCode_T(ii, :), ...
        StimulusType_T(ii, :), window );
    
    for jj = 1:size(feature, 1)
        feature(jj, :) = filter(d, feature(jj, :) );  
    end
   
    X = [X ; feature];
    Y = [Y ; label];
    
end

test_x = X;
test_y = Y;