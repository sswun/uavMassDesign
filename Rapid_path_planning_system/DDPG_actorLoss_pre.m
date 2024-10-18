function [actorLoss,actorGradients] = DDPG_actorLoss_pre(actor,state_input,action_input)
%% DDPG算法中actor部分损失_预学习
% Critic损失和梯度
% state_input = dlarray(state,'BC');  
% action_input = dlarray(action,'BC');  
predictedActions = predict(actor, state_input);
actorLoss = mse(predictedActions,action_input);
[actorGradients] = dlgradient(actorLoss, actor.Learnables);
end
