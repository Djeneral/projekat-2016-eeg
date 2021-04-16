% generate big matrix

T = [X, Y];

T = sortrows(T, window+1);

M = T(:, 1:window);
N = T(:, window+1);

n = 20;% want 20-row average.

clear temp;
clear matrix_avg;

% reshape
tmp = reshape(M, [n prod(size(M))/n]);
% mean column-wise (and only 9 rows per col)
tmp = mean(tmp);    
% reshape back
matrix_avg = reshape(tmp, [ size(M,1)/n size(M,2) ]);

N = N(1:20:size(Y,1));

X = matrix_avg;
Y = N;

X = X - repmat(mean(X')', 1, window);
