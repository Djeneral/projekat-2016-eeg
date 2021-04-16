
%
%       POTREBNO JE DEFINISATI  
%           rec_idx - Definiše redni broj snimka koji se obra?uje.
%       PRE POKRETANJA SKRIPTE
%                              

%% Definisanje signala 

sig = Signal(rec_idx, :, channel); % Signal na datom kanalu na sa datog snimka.

%% Izvo?enje i filtriranje signala
% Na slici je predstavljen izvedeni sirovi signal, kao i filtrirana verzija

figure(1);
hold on;

%plot(sig, 'r');
sig = filter(filt, sig); % Filtriran signal
%plot(sig, 'b');

sig = sig( FiltOrder/2 :end ); % Transliran signal ulevo

%plot(sig, 'k');

%% Dobijanje epoha
    
sigCode = StimulusCode(rec_idx, :); % Izvu?i položaje epoha  

sigCode = sigCode(1:end-FiltOrder/2); %Trim sigCode
flashing = (sigCode ~= 0);

epochs = zeros(12, 15, window);

stim_idx = ones(1, 12);

for n = 2 : length(sig) - window
    if (flashing(n-1) == 1 && flashing(n) == 0) % Ako je sijalica ugašena
       sid = sigCode(n-1);
       epochs(sid, stim_idx(sid), :) = sig(n:n+window-1); % Izvla?enje epoha
       stim_idx(sid) = stim_idx(sid) + 1; % Na?en stimulus 'sid'
    end
end

%% Dobijanje srednjih pozitivnih i negativnih epoha

[col_id, row_id] = Char2ColRow (screen, TargetChar(rec_idx)); % Odre?ivanje kolone i reda trenutnog slova

pos_stimuli = [col_id, row_id + 6] ; % Odre?ivanje pozitivnog stimulusa
neg_stimuli = setdiff(1:12, pos_stimuli); % Negativni stimulusi su svi oni koji nisu pozitivni 

%%% Dobijanje srednje pozitivne epohe
pos_epoch = epochs(pos_stimuli, :, :); % Odre?ivanje negativnih epoha na osnovu stimulusa

avg_pos_epoch_by_stim = mean ( pos_epoch, 2 );
avg_pos_epoch_by_stim = reshape(avg_pos_epoch_by_stim, length(pos_stimuli), window);  % Srednje epohe po stimulusima

avg_pos_epoch = mean( avg_pos_epoch_by_stim, 1 ); 
avg_pos_epoch = reshape ( avg_pos_epoch, 1, [] ); % Srednja epoha 

%%% Dobijanje srednje negativne epohe
neg_epoch = epochs(neg_stimuli, :, :); % Odre?ivanje negativnih epoha na osnovu stimulusa

avg_neg_epoch_by_stim = mean ( neg_epoch, 2 );
avg_neg_epoch_by_stim = reshape(avg_neg_epoch_by_stim, length(neg_stimuli), window);  % Srednje epohe po stimulusima

avg_neg_epoch = mean( avg_neg_epoch_by_stim, 1 ); 
avg_neg_epoch = reshape ( avg_neg_epoch, 1, [] ); % Srednja epoha 

%% Prikaz svih pozitivnih i negativnih epoha

% figure(3);
% 
% for idx = 1:2
%     subplot(3, 4, idx);
%     plot ( avg_pos_epoch_by_stim(idx, :) );
%     title('+1');
% end
% 
% for idx = 1:10
%     subplot(3, 4, idx+2);
%     plot ( avg_neg_epoch_by_stim(idx, :) );
%     title('-1');
% end



%% Prikaz rezultata
% 
% figure(2);
% hold on;
% plot(avg_pos_epoch, 'r')
% plot(avg_neg_epoch, 'b')
% legend('Srednja pozitivna epoha', 'Srednja negativna epoha');

%% Puni trening i test set

X = [X; avg_pos_epoch];
y = [y; +1];
X = [X; avg_neg_epoch];
y = [y; -1];



