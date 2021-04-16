function [ precision, accuracy, recall ] = calcMetric_( true_labels, class_labels )
%A_ Summary of this function goes here
%   Detailed explanation goes here
    tp  = sum ( true_labels > 0 & class_labels > 0 );
    tn  = sum ( true_labels <= 0 & class_labels <= 0 );
    fn= sum ( true_labels > 0 & class_labels <= 0 );
    fp = sum ( true_labels <= 0 & class_labels > 0 );
    
    precision = tp / (tp + fp);
    recall = tp / (tp + fn);
    accuracy = (tp + tn)/(tp + tn + fp + fn);
    
    fprintf('Precision: %.2f%%\nRecall: %.2f%%\nAccuracy: %.2f%%\n', precision*100, recall*100, accuracy*100);
    
end

