function [Y]=bppredict(P,net)
%% ≤‚ ‘
Y=sim(net,P);
Y=Y';