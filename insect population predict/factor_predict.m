function [Evaluation,pred,really,net]=factor_predict(data,lag,horizon,method_type,mode)

%% ѡ����෽��
switch method_type
    
    case 'base'
        
        end_train=floor(length(data)*0.90);  %%%����ѵ�������Լ�
        [X_train,Y_train,X_test,Y_test]=transfer(data,lag,horizon,1,1,end_train);
        %��һ��
        [X_train,inputps]=mapminmax(X_train);
        X_test=mapminmax('apply',X_test,inputps);
        [Y_train,outputps]=mapminmax(Y_train);
        %Ԥ��
        [pred,net]=predict_method(X_train,Y_train,X_test,Y_test,mode);
        %����һ��
        pred=mapminmax('reverse',pred,outputps);
        Y=Y_test;
        
        
end
%% ������������ָ��
[Evaluation(:,1),Evaluation(:,2),Evaluation(:,3)]=ptest(pred',Y_test');
really=Y_test';
