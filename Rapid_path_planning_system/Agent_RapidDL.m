classdef Agent_RapidDL < handle  
    %% 快速强化学习算法Agent
    properties  
        actor;  % 动作网络
        action_dim;  % 动作维度
        state_dim;  % 状态维度
        hidden_dim = 256;  % 隐含层数量
        learnRate = 0.0001;  % 学习率
        sigma = 0.005; % 随机系数
        replayBuffer;  % 经验回放池
        vel_act=[];
    end  
      
    methods  
        function obj = Agent_RapidDL(action_dim,state_dim)
            % 初始化
            obj.action_dim = action_dim;
            obj.state_dim = state_dim;

            % 初始化actor网络
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
        end

        function obj = add_experience(obj,SA)
            % 增加经验回访池内容
            obj.replayBuffer = [obj.replayBuffer;SA];
        end

        function obj = delete_experience(obj,num)
            % 删除经验回访池内容
            obj.replayBuffer(num,:) = [];
        end

        function obj = pop_experience(obj,num)
            % 将经验池中最后的num个数pop出去
            obj.replayBuffer(1:num,:) = [];
        end

        function obj = reset_vel(obj)
            % 重设动量因子
            obj.vel_act = [];
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

        function obj = update(obj,batch_size)
            % 学习更新网络参数
            minibatch = obj.sample(batch_size);
            state = minibatch(:,1:obj.state_dim);  % 状态S
            action = minibatch(:,obj.state_dim+1:obj.state_dim+obj.action_dim);  % 动作A

            state_input = dlarray(state,'BC');
            action_input = dlarray(action,'BC');

            % function [actorLoss,actorGradients] = DDPG_actorLoss_pre(actor,state_input,action_input)
            [~,actorGradients] = dlfeval(@DDPG_actorLoss_pre,obj.actor,state_input,action_input);
            [obj.actor,obj.vel_act] = sgdmupdate(obj.actor,actorGradients,obj.vel_act,obj.learnRate);
        end
    end

end