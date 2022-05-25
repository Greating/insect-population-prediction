function [net]=bptrain(P,T,N)

%% ´´½¨ÍøÂç
net=feedforwardnet(N);
net.trainFcn='traingdx';
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';

%% ÑµÁ·ÍøÂç
net=train(net,P,T);