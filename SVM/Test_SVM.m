X = []; % Feature matrica
y = []; % Labela feature matrice

set(0,'DefaultFigureVisible','off'); % Isklju?i prikazivanje figura
for rec_idx = 1:TestSetSize
    fprintf('Obrada snimka %i...\n', rec_idx);
    run GetReducedFeatures_SVM; % Pokretanje procedure treniranja SVM-a
end
set(0,'DefaultFigureVisible','on'); %Uklju?i prikazivanje figura
% Nakon izvršenja skripte, pune su promenljive X, y.

% Nakon prikupljanja trening i test setova vrši se treniranje

disp('Testiranje u toku...');
tic
y_c = svmclassify(svm_classifier, X);
toc
disp('\n');

[acc, prec, reca] = calcMetric(y, y_c);