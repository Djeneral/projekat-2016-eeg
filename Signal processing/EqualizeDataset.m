function [ f2, l2 ] = EqualizeDataset( f1, l1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    T = [f1, l1];
    
    sort(T, size(T, 1));
   
    Tp = T( T(: ,end) > 0 , :);
    Tn = T( T(: ,end) <= 0 , :);
    
    ordering = randperm(size(Tn, 1));
    Tn = Tn(ordering, :);
    Tn = Tn(1:size(Tp, 1), :);
   
    
    T = [Tp; Tn];
    
    f2 = T(:, 1:end-1);
    l2 = T(:, end);
end

