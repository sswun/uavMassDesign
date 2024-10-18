function [loss,Gradients,state] = netLoss_cal(net,inputs,labels)
%% 损失函数设计
[out,state] = forward(net, inputs);  % 网络前向传播获得输出
loss = crossentropy(out,labels);  % 交叉熵损失函数
Gradients = dlgradient(loss, net.Learnables);  % 获得梯度信息
end

