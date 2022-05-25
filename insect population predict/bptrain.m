function [net]=bptrain(P,T,N)

%% ��������
net=feedforwardnet(N);
net.trainFcn='traingdx';
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';

%% ѵ������
net=train(net,P,T);