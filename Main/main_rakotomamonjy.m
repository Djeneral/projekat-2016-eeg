prepareData = 0;

if (prepareData > 0)

clear all;
close all;
clc;

TargetChar=[];
StimulusType=[];

subject = 'A';  % Odabir subjekta 'A' / 'B'

fprintf(1, 'Loading... \n\n' );

load Subject_A_Train.mat; % load data 

%Signal_T = Signal; % Test set
%Flashing_T = Flashing;
%StimulusCode_T = StimulusCode;

%load Subject_A_Train.mat % load data 
channel=51; % Cz ch
channels = [2 3 4 5 10 11 18 32 34 51]; % Ovo prvo menjati ako neradi !

%fid = fopen(['true_labels_', subject, '.txt']);
%TargetChar_T = fscanf(fid, '%s');
%fclose(fid);

% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
       
fs = 240;

window = floor(.666 * fs);

filt = designfilt('bandpassfir','FilterOrder',8, ...
         'CutoffFrequency1',0.5,'CutoffFrequency2',20, ...
         'SampleRate',240);

X = [];
y = [];

z = []
for ii = 1:5:85
   z = [z ; ii:ii+4]
end

classifiers = [];

options.MaxIter = 1e6;

for zz = z'
    
fprintf('Parsing classifier %i\n', zz(5)/5);

clear X y Xtt Xt

X = []';
y = [];

    for rec_idx = zz'
        fprintf('Parsing %i\n', rec_idx);

        sig_ch = Signal(rec_idx, :, :);

        sig_ch = reshape(sig_ch, size(Signal, 2), size(Signal, 3));

        let_id = find(screen == TargetChar_T(ii));
        col_id = mod(let_id, 6);
        row_id = (let_id - col_id)/6 + 1;
        StimulusType = StimulusCode == col_id | StimulusCode == row_id;
        
        Xt = [];   
        
        for ch = 1:64
            sig = sig_ch(:, ch);
            sig = reshape(sig, 1, []);

            [feature, label] = extract_feature( sig, StimulusCode(rec_idx, :), ...
                StimulusType(rec_idx, :), window );

            clear sig;

            Xtt = [];

            for ii = 1 : size(feature,1)
                sig = feature(ii, :);
                sig = double(sig);
                sig = filter(filt, sig);
                sig = decimate(sig,12,'fir');
                Xtt = [Xtt; sig];
            end

            Xt = [Xt, Xtt];
        end

        X = [X ; Xt];
        y = [y ; label];   
    end
    
    % Prepared X, y
    
    s = svmtrain( X, y, 'options', options, ...
    'kernel_function', 'linear', 'method', 'SMO');
    %'boxconstraint', 20.007);      

    classifiers = [classifiers s];
end

else    
    load classifiers.mat
end

fprintf('Done preparing data. \n');

%Testiranje

clear Signal 
clear Flashing 
clear StimulusCode 
clear StimulusType

load Subject_A_Test.mat

fid = fopen('true_labels_A.txt');

TargetChar_T = fscanf(fid, '%s');
fclose(fid);

screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
%halt;
fs = 240;

window = floor(.666 * fs);

filt = designfilt('bandpassfir','FilterOrder',8, ...
         'CutoffFrequency1',0.5,'CutoffFrequency2',20, ...
         'SampleRate',240);
        
X = [];
y = [];
     
for rec_idx = 1:100 % rec_idx
        fprintf('Deciding %i\n', rec_idx);

        sig_ch = Signal(rec_idx, :, :);

        sig_ch = reshape(sig_ch, size(Signal, 2), size(Signal, 3));

        let_id = find(screen == TargetChar_T(rec_idx));
        col_id = mod(let_id, 6);
        row_id = (let_id - col_id)/6 + 1;
        StimulusType = StimulusCode == col_id | StimulusCode == row_id;
        
        Xt = [];   
        
        for ch = 1:64
            sig = sig_ch(:, ch);
            sig = reshape(sig, 1, []);

            [feature, label] = extract_feature( sig, StimulusCode(rec_idx, :), ...
                StimulusType(rec_idx, :), window );

            Xtt = [];

            for ii = 1 : size(feature,1)
                sig = feature(ii, :);
                sig = double(sig);
                sig = filter(filt, sig);
                sig = decimate(sig,12,'fir');
                Xtt = [Xtt; sig];
            end

            Xt = [Xt, Xtt];
            
        end
    
        % Xt cuva feature vektor
        Xt
        % label je oznaka
        
        
        lc = []
        
        for s = 1:length(classifiers)
            fprintf('Classifier: %i \n', s);
            lc = [lc svmclassify(classifiers(s), Xt)];
        end
        
        halt;
end
