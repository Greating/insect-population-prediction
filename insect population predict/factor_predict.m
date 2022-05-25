function [Evaluation,pred,really,net]=factor_predict(data,lag,horizon,method_type,mode)

%% 选择大类方法
switch method_type
    
    case 'base'
        
        end_train=floor(length(data)*0.90);  %%%区分训练集测试集
        [X_train,Y_train,X_test,Y_test]=transfer(data,lag,horizon,1,1,end_train);
        %归一化
        [X_train,inputps]=mapminmax(X_train);
        X_test=mapminmax('apply',X_test,inputps);
        [Y_train,outputps]=mapminmax(Y_train);
        %预测
        [pred,net]=predict_method(X_train,Y_train,X_test,Y_test,mode);
        %反归一化
        pred=mapminmax('reverse',pred,outputps);
        Y=Y_test;
        
        
end
%% 计算三个评价指标
[Evaluation(:,1),Evaluation(:,2),Evaluation(:,3)]=ptest(pred',Y_test');
really=Y_test';
