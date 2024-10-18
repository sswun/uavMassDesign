classdef Agent_DDPG_2 < handle  
    %% 强化学习实现DDPG算法Agent
    properties  
        actor;  % 动作网络
        critic;  % 价值网络
        target_actor;  % 目标动作网络
        target_critic;  % 目标价值网络
        gamma = 0.1;  % TD算法gamma值
        sigma = 0.001;  % 高斯噪声标准差
        tau = 0.005;  % 软更新参数
        action_dim;  % 动作维度
        state_dim;  % 状态维度
        hidden_dim = 256;  % 隐含层数量
        learnRate = 0.0001;  % 学习率
        replayBuffer;  % 经验回放池
        vel_cri=[];
        vel_act=[];
    end  
      
    methods  
        function obj = Agent_DDPG_2(action_dim,state_dim)
            % 初始化
            obj.action_dim = action_dim;
            obj.state_dim = state_dim;

            % 初始化actor、target_actor网络
            layers_actor = [
                featureInputLayer(obj.state_dim,"Name","featureinput")
                fullyConnectedLayer(obj.hidden_dim,"Name","fc")
                reluLayer("Name","relu")
                fullyConnectedLayer(obj.hidden_dim,"Name","fc_add")
                reluLayer("Name","relu_add")
                fullyConnectedLayer(obj.hidden_dim,"Name","fc_add1")
                reluLayer("Name","relu_add1")
                fullyConnectedLayer(obj.action_dim,"Name","fc_1")
                tanhLayer("Name","tanh")];
            obj.actor = dlnetwork(layers_actor);
            obj.target_actor = dlnetwork(layers_actor);
            obj.target_actor = copy_net(obj.actor,obj.target_actor);  % 将网络参数复制

            % 初始化critic、target_critic网络
            layers_critic = [
                featureInputLayer(obj.state_dim + obj.action_dim,"Name","featureinput")
                fullyConnectedLayer(obj.hidden_dim,"Name","fc")
                reluLayer("Name","relu")
                fullyConnectedLayer(obj.hidden_dim,"Name","fc_add")
                reluLayer("Name","relu_add")
                fullyConnectedLayer(obj.hidden_dim,"Name","fc_add1")
                reluLayer("Name","relu_add1")
                fullyConnectedLayer(1,"Name","fc_1")];
            obj.critic = dlnetwork(layers_critic);
            obj.target_critic = dlnetwork(layers_critic);
            obj.target_critic = copy_net(obj.critic,obj.target_critic);  % 将网络参数复制
        end

        function obj = add_experience(obj,SARSD)
            % 增加经验回访池内容
            obj.replayBuffer = [obj.replayBuffer;SARSD];
        end

        function obj = delete_experience(obj,num)
            % 删除经验回访池内容
            obj.replayBuffer(num,:) = [];
        end

        function obj = reset_vel(obj)
            % 重设动量因子
            obj.vel_act = [];
            obj.vel_cri = [];
        end

        function minibatch = sample(obj,batch_size)
            % 采样经验回放池
            if batch_size > size(obj.replayBuffer,1)
                minibatch = obj.replayBuffer(randperm(size(obj.replayBuffer,1)),:);
                return
            else
                index = randperm(size(obj.replayBuffer,1));
                index = index(1:batch_size);
                minibatch = obj.replayBuffer(index,:);
                return
            end
        end

        function action = take_action(obj,state)
            % 采取动作
            state_input = dlarray(state,'BC');
            predictedActions = predict(obj.actor, state_input);
            action = extractdata(predictedActions); 
        end

        function action = take_action_addRand(obj,state)
            % 采取动作并添加随机噪声
            state_input = dlarray(state,'BC');
            predictedActions = predict(obj.actor, state_input);
            action = extractdata(predictedActions);
            action = action + obj.sigma*randn(obj.action_dim,1);
        end

        function obj = update_pre(obj,batch_size)
            % 预学习更新网络参数
            minibatch = obj.sample(batch_size);
            state = minibatch(:,1:obj.state_dim);  % 状态S
            action = minibatch(:,obj.state_dim+1:obj.state_dim+obj.action_dim);  % 动作A
            reward = minibatch(:,obj.state_dim+obj.action_dim+1);  % 奖励R
            state_next = minibatch(:,obj.state_dim+obj.action_dim+2:2*obj.state_dim+obj.action_dim+1);  % 下一状态S
            dones = minibatch(:,end);  % 游戏是否结束D

            % 预测下一个动作和目标Q值
            states_input = dlarray(state_next,'BC');
            predictedNextActions = predict(obj.target_actor, states_input);
            Q_value = predict(obj.target_critic, [states_input;predictedNextActions]);
            targetQValues = reward' + 0.1 * Q_value .*(1 - dones)';

            % Critic损失和梯度
            state_input = dlarray(state,'BC');
            action_input = dlarray(action,'BC');
            % [criticLoss,criticGradients] = DDPG_criticLoss(critic,state_input,action_input,targetQValues)
            [~,criticGradients] = dlfeval(@DDPG_criticLoss,obj.critic,state_input,...
                action_input,targetQValues);
            [obj.critic,obj.vel_cri] = sgdmupdate(obj.critic,criticGradients,obj.vel_cri,obj.learnRate);

            % function [actorLoss,actorGradients] = DDPG_actorLoss_pre(actor,state_input,action_input)
            [~,actorGradients] = dlfeval(@DDPG_actorLoss_pre,obj.actor,state_input,action_input);
            [obj.actor,obj.vel_act] = sgdmupdate(obj.actor,actorGradients,obj.vel_act,obj.learnRate);

            % 更新
            obj.target_actor = copy_net(obj.actor,obj.target_actor);
            obj.target_critic = copy_net(obj.critic,obj.target_critic);
        end

        function obj = update(obj,batch_size)
            % 更新网络参数
            minibatch = obj.sample(batch_size);
            state = minibatch(:,1:obj.state_dim);  % 状态S
            action = minibatch(:,obj.state_dim+1:obj.state_dim+obj.action_dim);  % 动作A
            reward = minibatch(:,obj.state_dim+obj.action_dim+1);  % 奖励R
            state_next = minibatch(:,obj.state_dim+obj.action_dim+2:2*obj.state_dim+obj.action_dim+1);  % 下一状态S
            dones = minibatch(:,end);  % 游戏是否结束D

            % 预测下一个动作和目标Q值
            states_input = dlarray(state_next,'BC');
            predictedNextActions = predict(obj.target_actor, states_input);
            Q_value = predict(obj.target_critic, [states_input;predictedNextActions]);
            targetQValues = reward' + obj.gamma * Q_value .*(1 - dones)';

            % Critic损失和梯度
            state_input = dlarray(state,'BC');
            action_input = dlarray(action,'BC');
            % [criticLoss,criticGradients] = DDPG_criticLoss(critic,state_input,action_input,targetQValues)
            [~,criticGradients] = dlfeval(@DDPG_criticLoss,obj.critic,state_input,...
                action_input,targetQValues);
            [obj.critic,obj.vel_cri] = sgdmupdate(obj.critic,criticGradients,obj.vel_cri,obj.learnRate);

            % [actorLoss,actorGradients] = DDPG_actorLoss(actor,critic,state_input)
            [~,actorGradients] = dlfeval(@DDPG_actorLoss,obj.actor,obj.critic,state_input);
            [obj.actor,obj.vel_act] = sgdmupdate(obj.actor,actorGradients,obj.vel_act,obj.learnRate);

            % 更新
            obj.target_actor = copy_net(obj.actor,obj.target_actor);
            obj.target_critic = copy_net(obj.critic,obj.target_critic);
        end
    end

end