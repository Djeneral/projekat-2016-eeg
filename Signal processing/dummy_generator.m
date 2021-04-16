
window = 240;
test_size = 4000;
train_size = 1000;

test_label = [];
train_label = [];
test_data = [];
train_data = [];

sig = zeros(1, window);
n_of_ch = 1; 

for ii = 1:test_size

    x = window / 10 + 2 * randn(1);
    y = x + 50;
    sig(1, :) =((1:window) >= x & (1:window) <= y) + .1 * randn(1,window);
    
    test_data(ii, :, 1) = sig(1, :);
    
    delay_factor = (randn(1) > 0);
    
    for jj = 1:n_of_ch
        test_data(ii, :, jj) = sig(jj, :);
        x = window / 10 + 2 * randn(1) + 2 * delay_factor * abs(randn(1)*60);
        y = x + 50;
        sig(jj, :) =((1:window) >= x & (1:window) <= y) + .1 * randn(1,window);
        test_data(ii, :, jj) = sig(jj, :);
    end
    
    test_label(ii) = 2*delay_factor - 1;
end

for ii = 1:train_size

    x = window / 10 + 2 * randn(1);
    y = x + 50;
    sig1 =((1:window) >= x & (1:window) <= y) + .1 * randn(1,window);
   
    delay_factor = (randn(1) > 0);
    
    x = window / 10 + 2 * delay_factor * 60;
    y = x + 50;
    sig2 =((1:window) >= x & (1:window) <= y) + .1 * randn(1,window);
   
    train_data(ii, :, 1) = sig1;
    train_data(ii, :, 2) = sig2;
    train_label(ii) = 2*delay_factor - 1;
    
end
