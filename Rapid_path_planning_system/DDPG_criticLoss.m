function [criticLoss,criticGradients] = DDPG_criticLoss(critic,state_input,action_input,targetQValues)
%% DDPG算法中critic部分损失
% Critic损失和梯度
% state_input = dlarray(state,'BC');  
% action_input = dlarray(action,'BC');  

% 确保状态和动作在正确的维度上连接  
% 如果需要，你可能需要调整这里的连接逻辑  
input_combined = [state_input; action_input]; % 或者使用其他适当的连接方式  
  
out_critic = forward(critic, input_combined);  
criticLoss = mean((out_critic - targetQValues).^2);

[criticGradients] = dlgradient(criticLoss, critic.Learnables);
end

