%% ��Ҫ����Ԥ��
function [pred,net]=predict_method(X_train,Y_train,X_test,Y_test,mode)
%ѡ��Ԥ��ģ��
switch mode
    
    case 'BP'
        Y=[];
        for k=1:1
            N=10;
            [net]=bptrain(X_train,Y_train,N);
            load('net')
            [pred]=bppredict(X_test,net);
            Y=[Y pred];
        end
        pred=mean(Y,2);
        
end
end