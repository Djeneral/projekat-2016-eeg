run init_rakotomamonjy;

prepareData = 1;

if (prepareData > 0)


load Subject_A_Train.mat; % load data 

for ii = 1:5:85 
    z = [z ; ii:ii+4];    
end

classifiers = [];

options.MaxIter = 1e6;

StimulusCode = StimulusCode(:, 1:size(StimulusCode, 2)-127);
StimulusType = StimulusType(:, 1:size(StimulusType, 2)-127);


for zz = z'
    
fprintf('Training classifier %i\n', zz(5)/5);

clear X y Xtt Xt

X = [];
y = [];

    for rec_idx = zz'
        fprintf(' - Parsing %i\n', rec_idx);
    
        sig = SignalConditioningSVM(Signal, rec_idx, channel, filt);
        
        feature = [];
        label = [];
        
        [feature, label] = extract_feature( sig, StimulusCode(rec_idx, :), ...
            StimulusType(rec_idx, :), window );

        [feature, label] = EqualizeDataset(feature, label);
        disp(size(feature,1))
        
        clear sig;

        for ii = 1 : size(feature,1)
            sig = feature(ii, :);
            
            sig = EpochConditioning( sig );
          
            X = [X; sig];
        end
        
        y = [y ; label];   
    end
    
    % Prepared X, y
    tic
    s = svmtrain( X, y, 'options', options, ...
    'kernel_function', 'rbf', 'method', 'SMO');
    fprintf('Train time : ')
    toc 
    fprintf('\n');
    
    %'boxconstraint', 20.007);      

    classifiers = [classifiers s]; %Treniraj 17 klasifikatora 
end

else    
    load classifiers.mat
end

fprintf('Done preparing data. \n');

%Testiranje

%clear Signal 
%clear Flashing 
%clear StimulusCode 
%clear StimulusType

%load Subject_A_Train.mat

StimulusCode = StimulusCode(:, 1:(size(StimulusCode, 2)-127));
StimulusType = StimulusType(:, 1:(size(StimulusType, 2)-127));

TargetChar_T = TargetChar;

%fid = fopen('true_labels_A.txt');
%TargetChar_T = fscanf(fid, '%s');
%fclose(fid);
        
X = [];
y = [];

sss = [];

for rec_idx = 1:100 % rec_idx
        fprintf('Deciding %i\n', rec_idx);

        sig = SignalConditioningSVM(Signal, rec_idx, channel, filt);
        

        [col_id, row_id] = Char2ColRow( screen, TargetChar_T(rec_idx));
        StimulusType_T(rec_idx, :) = StimulusCode(rec_idx,:) == row_id+6 | StimulusCode(rec_idx,:) == col_id;
        
        %halt;
        
        X = [];   
        
        [feature, label] = extract_feature( sig, StimulusCode(rec_idx, :), ...
            StimulusType_T(rec_idx, :), window );

        Xt = [];   
        for ii = 1 : size(feature,1)
            sig = feature(ii, :);
            sig = EpochConditioning(sig);
            Xt = [Xt; sig];
        end

        X = [X, Xt];
        
        y = [y; label];
        
        lc = [];
        fprintf('Clasification: ');
        for s = 1:length(classifiers)
            fprintf('|');
            lc = [lc svmclassify(classifiers(s), X)];
        end
        fprintf('\n');
      
        sss = [sss; lc];        
end

% Metric

l2 = (y + 1 ) / 2;
acc = sum(l2 == (sum(sss')' > 0)) / length(l2);

calcMetric(l2, sum(sss')' > 0);

disp(acc);
