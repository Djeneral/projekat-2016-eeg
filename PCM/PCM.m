function [Correlation_coeficient] = PCM(X,Y)
% n=size(X,1);
% sumX=sum(X);
% sumY=sum(Y);
% A = n*(sum(X.*Y))-sumX*sumY;
% B = sqrt(n*(sum(X.^2)-(sumX)^2)*(n*sum(Y.^2)-(sumY)^2));
% Correlation_coeficient=A/B;

meanY=mean(Y);
meanX=mean(X);
A=sum(X.*(Y-meanY)-meanX.*(Y-meanY));
B=sqrt(sum((X-meanX).^2)*(sum((Y-meanY).^2)));
Correlation_coeficient=A/B;

end

