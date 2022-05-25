function [Dstat,MAPE,RMSE]=ptest(AA,TT)

% this programme is used to evaluate the accuracy lever of prediction result AA

% input: AA -1*k         the prediction result
%        TT -1*k or k*1  the actual value of the predicted data 

% output: aaa=[Dstat;MAPE;RMSE]; MAPE - mean absolute percetage error;
%         RMSE - root mean squared error; Dstat - directional statistics

 
[g,k]=size(AA);sum1=0;sum2=0;sum3=0;

for kk=1:k
    
    a=abs((AA(kk)-TT(kk))/TT(kk));   % MAPE
    sum1=a+sum1;
    
    b=(AA(kk)-TT(kk))^2;             % RMSE
    sum2=b+sum2;
    
end

MAPE=sum1/k;        % MAPE
RMSE=(sum2/k)^0.5;  % RMSE
    
for kkk=2:k
    if (AA(kkk)-TT(kkk-1))*(TT(kkk)-TT(kkk-1))>=0
        c(kkk)=1;
    else
        c(kkk)=0;
    end
        sum3=sum3+c(kkk);
end

Dstat=sum3/(k-1);  % Dstat