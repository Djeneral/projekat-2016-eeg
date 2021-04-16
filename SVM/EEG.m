clear all
close all
clc

run Init_SVM

channels = 3;

% Loading data

for NumberOfEpochsUsed  = 1:15
    fprintf('Usrednjava se %i epocha\n', NumberOfEpochsUsed);
    
    load Subject_A_Train.mat;
    TrainSetSize = 85;
        
    for channel = channels
        
        fprintf('Zapoceto treniranje, kanal: %i...\n', channel);
        run Train_SVM
        fprintf('Zavrseno treniranje, kanal: %i...\n', channel);

        classifiers(channel) = svm_classifier;
    end 

    clear Signal
    clear Flashing
    clear StimulusCode
    clear StimulusType
    clear TargetChar

    load Subject_A_Test.mat;

    % Gets, Flashing, StimulusCode, Signal

    TestSetSize = 100;

    fid = fopen(['true_labels_A.txt']);
    TargetChar = fscanf(fid, '%s');
    fclose(fid);

    %Loading

    for channel = channels
        fprintf('Zapoceto testiranje, kanal: %i...\n', channel);
        run Test_SVM
        fprintf('Zavrseno testiranje, kanal: %i...\n', channel);

        accuracy(NumberOfEpochsUsed) = acc;
        precision(NumberOfEpochsUsed) = prec;
        recall(NumberOfEpochsUsed) = reca;
    end 
end
