% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
        
fs = 240; 

window = floor ( 0.666 * fs );

filt = fir256;
FiltOrder = 256;

%NumberOfEpochsUsed = 5; % Broj epoha koje se usrednjavaju.

options.MaxIter = 1e6;