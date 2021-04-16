clear all
close all
clc

run Init_SVM;

noeu = 6:9; % Broj epoha koje se usrednjavaju

if (1==2)
    
load Subject_A_Train.mat

train_data = [];
train_label = [];

fprintf('Obrada Train seta \n');
for NumberOfEpochsUsed = noeu
    for channel = 1:64
        fprintf('Kanal: %i\n', channel);
        X = [];
        y = [];
        for rec_idx = 1:85
            run GetReducedFeatures_SVM;
        end   
        train_data(NumberOfEpochsUsed, channel, :, :) = X;
        train_label(NumberOfEpochsUsed, channel, :) = y;
    end
end

clear Signal
clear Flashing
clear StimulusCode
clear StimulusType
clear TargetChar

end;

load Subject_A_Test.mat

fid = fopen(['true_labels_A.txt']);
TargetChar = fscanf(fid, '%s');
fclose(fid);
test_data = [];
test_label = [];

fprintf ('Obrada Test seta \n');
for NumberOfEpochsUsed = noeu
    for channel = 1:64  
        fprintf('Kanal: %i\n', channel);
        X = [];
        y = [];
        for rec_idx = 1:100
            run GetReducedFeatures_SVM;
        end   
        test_data(NumberOfEpochsUsed, channel, :, :) = X;
        test_label(NumberOfEpochsUsed, channel, :) = y;
    end
end