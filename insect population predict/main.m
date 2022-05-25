%% ��ջ���
clc;
clear;

%% ��������
N = 1000;
load('data')
data = data*N;
data = repmat(data,10,1);

%% Ԥ��
lag=28;
horizon=1;
[~,pred,real,net]=factor_predict(data,lag,horizon,'base','BP');
pred = pred/N;
real = real/N;

%% ��ͼ
figure()
t=2000:1:2002;
plot(t,real(end-2:end),'r*-')
hold on
plot(t,pred(end-2:end),'b-')
hold on
plot(t,real(end-2:end)-pred(end-2:end),'y-')
ylim([-0.3,0.5])
set(gca,'XTick',[2000:1:2002])
title('��ʵֵ��Ԥ��ֵ�Ա�ͼ')
legend('��ʵֵ','Ԥ��ֵ','���')

%% ��ͼ
figure()
t1=1975:1:2002;
plot(t1,real(end-27:end),'r*-')
hold on
t2=2000:1:2002;
plot(t2,pred(end-2:end),'b-')
% ylim([-0.3,0.5])
title('��ʵֵ��Ԥ��ֵ�Ա�ͼ')
legend('��ʵֵ','Ԥ��ֵ')

%% ��ʾԤ��ֵ
disp("Ԥ��ֵ�ǣ�");
pred