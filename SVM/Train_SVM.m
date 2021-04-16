X = []; % Feature matrica
y = []; % Labela feature matrice

set(0,'DefaultFigureVisible','off'); % Isklju?i prikazivanje figura
for rec_idx = 1:TrainSetSize
    fprintf('Obrada snimka %i...\n', rec_idx);
    run GetReducedFeatures_SVM; % Pokretanje procedure treniranja SVM-a sa manje (NumberOfEpochsUsed) epoha
end
set(0,'DefaultFigureVisible','on'); %Uklju?i prikazivanje figura
% Nakon izvršenja skripte, pune su promenljive X, y.

% Nakon prikupljanja trening i test setova vrši se treniranje

disp('Treniranje u toku...');
tic
svm_classifier = svmtrain(X, y, 'options', options, 'kernel_function', 'linear');
toc
disp('\n');
