%% 清空环境
clc;
clear;

%% 加载数据
N = 1000;
load('data')
data = data*N;
data = repmat(data,10,1);

%% 预测
lag=28;
horizon=1;
[~,pred,real,net]=factor_predict(data,lag,horizon,'base','BP');
pred = pred/N;
real = real/N;

%% 画图
figure()
t=2000:1:2002;
plot(t,real(end-2:end),'r*-')
hold on
plot(t,pred(end-2:end),'b-')
hold on
plot(t,real(end-2:end)-pred(end-2:end),'y-')
ylim([-0.3,0.5])
set(gca,'XTick',[2000:1:2002])
title('真实值与预测值对比图')
legend('真实值','预测值','误差')

%% 画图
figure()
t1=1975:1:2002;
plot(t1,real(end-27:end),'r*-')
hold on
t2=2000:1:2002;
plot(t2,pred(end-2:end),'b-')
% ylim([-0.3,0.5])
title('真实值与预测值对比图')
legend('真实值','预测值')

%% 显示预测值
disp("预测值是：");
pred