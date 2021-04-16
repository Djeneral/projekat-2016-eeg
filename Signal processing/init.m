clear all;
close all;
clc;

number_of_chanells = 64;

TargetChar=[];
StimulusType=[];

subject = 'A';  % Odabir subjekta 'A' / 'B'

fprintf(1, 'Loading... \n\n' );

load Subject_A_Test.mat % load data 

Signal_T = Signal; % Test set
Flashing_T = Flashing;
StimulusCode_T = StimulusCode;

load Subject_A_Train.mat % load data 
window=240; % window = 1s
channel=51; % Cz ch
channels = [51];

fid = fopen(['true_labels_', subject, '.txt']);
TargetChar_T = fscanf(fid, '%s');
fclose(fid);

responses = [];

% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
        
number_of_recordings = 85;
       
class_correct = 0;
class_wrong = 0;

%Bandpass filter 

Fstop1 = 0.3;
Fpass1 = 0.7;
Fpass2 = 5;
Fstop2 = 6;
Astop1 = 20;
Apass  = 20;
Astop2 = 20;
Fs = 240;

d = designfilt('bandpassfir', ...
  'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
  'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
  'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
  'StopbandAttenuation2',Astop2, ...
  'DesignMethod','equiripple','SampleRate',Fs);