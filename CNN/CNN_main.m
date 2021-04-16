% run GetDataForCNNAtt.m;
% Kada se dobiju rezultati moguce je uraditi samo:
% Load('CNNdata.m');

% Ovdje dobijemo 4 matrice 
% TrainingData, TrainingLabel, TestData, TestLabel koje sluze za trening i
% test klasifikatora

inputlayer = imageInputLayer([64 78]);
convlayer1 = convolution2dLayer([64 1],78);
convlayer2 = convolution2dLayer([13 1],6);
fullconnectlayer1 = fullyConnectedLayer(100);
fullconnectlayer2 = fullyConnectedLayer(2);
coutputlayer = classificationLayer();

layers = [inputlayer;
          convlayer1;
          convlayer2;
          fullconnectlayer1;
          fullconnectlayer2;
          coutputlayer];
      
net = feedforwardnet; %create net object
net.name = 'Convolutional Neural Network for classification P300 ERP'; % define name
net.numLayers = 6; % define number of layers
net.layers = layers; % set layers
