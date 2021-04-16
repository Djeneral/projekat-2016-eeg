run init.m;
TrainingData =  zeros(64,765,240);
TrainingLabel = zeros(64,765);
TestData =  zeros(64,18000,240);
TestLabel = zeros(64,18000);


for ii=1:64
fprintf('Working on %i-th channel...\n', ii);
channel = ii;
channels = channel;
run format_dataset_cnn.m;
TrainingData(ii,:,:) = train_x;
TrainingLabel(ii,:) = train_y;
TestData(ii,:,:) = test_x;
TestLabel(ii,:) = test_y;
end;
