function [actorLoss,actorGradients] = DDPG_actorLoss(actor,critic,state_input)
%% DDPG算法中actor部分损失
% Critic损失和梯度
% state_input = dlarray(state,'BC');  
% action_input = dlarray(action,'BC');  

% Actor损失和梯度（使用确定性策略梯度）
predictedActions = predict(actor, state_input);
actorLoss = -mean(predict(critic, [state_input;predictedActions])); % 注意这里的负号，因为我们希望最大化Q值
[actorGradients] = dlgradient(actorLoss, actor.Learnables);
end

