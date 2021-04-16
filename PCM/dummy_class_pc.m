w = zeros(1, 240);

training = [ train_data(:, :, 1), train_data(:, :, 2) ] ;

for ii = 1 : 480
        w(ii) = PCM( training(:, ii)' , train_label );
end


x = []

test = [ test_data(:, :, 1), test_data(:, :, 2) ] ;

for ii = 1 : test_size
    x(ii) = sum(w .* test(ii, :));
end

acc = mean( ( 2*(x > 0)-1 ) == test_label )



