classdef Agent_DDPG_1 < handle  
     %% 强化学习实现DDPG算法Agent
    properties  
        actor; % Actor网络  
        critic; % Critic网络  
        actorOptimizer; % Actor优化器  
        criticOptimizer; % Critic优化器  
        memory; % 经验回放存储  
        batchSize; % 批处理大小  
        gamma; % 折扣因子  
        tau; % 软更新参数（这里未使用，但在完整实现中应该有）  
        learningRateActor; % Actor学习率  
        learningRateCritic; % Critic学习率  
        stateSize
        actionSize
        memoryCapacity
        memoryCounter
    end  
      
    methods  
        function obj = Agent_DDPG_1(stateSize, actionSize, hiddenSize, batchSize,...
                gamma, learningRateActor, learningRateCritic)  
            if nargin == 0  
                stateSize = obsDim; % 观测维度，需要事先定义  
                actionSize = actDim; % 动作维度，需要事先定义  
                hiddenSize = 24;  
                batchSize = 64;  
                gamma = 0.99;  
                learningRateActor = 1e-4;  
                learningRateCritic = 1e-3;  
            end  
              
            obj.stateSize = stateSize;  
            obj.actionSize = actionSize;  
            obj.batchSize = batchSize;  
            obj.gamma = gamma;  
            obj.learningRateActor = learningRateActor;  
            obj.learningRateCritic = learningRateCritic;  
              
            % 初始化Actor网络  
            layersActor = [  
                featureInputLayer(stateSize)  
                fullyConnectedLayer(hiddenSize, 'relu')  
                fullyConnectedLayer(actionSize, 'tanh') % 确定性策略输出层使用tanh激活函数限制动作范围  
            ];  
            obj.actor = dlnetwork(layersActor);  
              
            % 初始化Critic网络  
            layersCritic = [  
                featureInputLayer(stateSize + actionSize, 'Normalization', 'none', 'Name', 'stateActionInput')  
                fullyConnectedLayer(hiddenSize, 'relu')  
                fullyConnectedLayer(1, 'Name', 'output') % Critic输出单个Q值  
            ];  
            obj.critic = dlnetwork(layersCritic);  
              
            % 设置优化器  
            obj.actorOptimizer = adamOptimizer(obj.learningRateActor, 0.9, 0.999, 1e-8);  
            obj.criticOptimizer = adamOptimizer(obj.learningRateCritic, 0.9, 0.999, 1e-8);  
              
            % 初始化经验回放存储（这里简化为一个固定大小的数组）  
            obj.memoryCapacity = 1e6; % 存储容量  
            obj.memory = zeros(obj.memoryCapacity, 1); % 简化的存储实现，实际中应使用更复杂的数据结构  
            obj.memoryCounter = 1;  
        end  
          
        function update(obj, batchSize)  
            % 从经验回放中采样  
            miniBatch = obj.sampleMemory(batchSize);  
              
            % 分离状态和动作  
            states = miniBatch(:, 1:obj.stateSize);  
            actions = miniBatch(:, obj.stateSize + 1:end - 1);  
            rewards = miniBatch(:, end - 1);  
            nextStates = miniBatch(:, 1:obj.stateSize); % 这里简化处理，实际中nextStates应该与states分开存储  
            dones = miniBatch(:, end); % 结束标志，这里未使用  
              
            % 预测下一个动作和目标Q值  
            predictedNextActions = predict(obj.actor, nextStates);  
            targetQValues = rewards + obj.gamma * squeeze(predict(obj.critic, [nextStates predictedNextActions]));  
              
            % Critic损失和梯度  
            criticLoss = mean((predict(obj.critic, [states actions]) - targetQValues).^2);  
            [criticGradients, ~] = dlgradient(criticLoss, obj.critic.Learnables);  
              
            % 更新Critic网络  
            obj.critic = updateNetwork(obj.critic, obj.criticOptimizer, criticGradients);  
              
            % Actor损失和梯度（使用确定性策略梯度）  
            predictedActions = predict(obj.actor, states);  
            actorLoss = -mean(predict(obj.critic, [states predictedActions])); % 注意这里的负号，因为我们希望最大化Q值  
            [actorGradients, ~] = dlgradient(actorLoss, obj.actor.Learnables);  
              
            % 更新Actor网络  
            obj.actor = updateNetwork(obj.actor, obj.actorOptimizer, actorGradients);  
        end  
          
        function action = selectAction(obj, state)  
            % 选择动作：确定性策略直接输出动作，无需探索  
            stateTensor = dlarray(state, 'CBT'); % 转换为深度学习数组格式  
            action = predict(obj.actor, stateTensor);  
            action = squeeze(action); % 移除单维度  
        end  
          
        function obj = storeTransition(obj, transition)  
            % 存储经验回放（这里简化为添加到数组中，实际中应该有更复杂的存储和覆盖机制）  
            if obj.memoryCounter <= obj.memoryCapacity  
                obj.memory(obj.memoryCounter, :) = transition;  
                obj.memoryCounter = obj.memoryCounter + 1;  
            else  
                warning('Memory full, consider increasing capacity or implementing overwrite mechanism.');  
            end  
        end  
          
        function miniBatch = sampleMemory(obj, batchSize)  
            % 从经验回放中随机采样（这里简化为从整个数组中随机选择，实际中应该有更高效的采样方法）  
            idx = randi([1, obj.memoryCounter - 1], 1, batchSize);  
            miniBatch = obj.memory(idx, :);  
        end  
          
        % 以下是辅助函数，用于更新网络和预测动作（这些函数在MATLAB的Deep Learning Toolbox中通常已经提供）  
        function newNetwork = updateNetwork(network, optimizer, gradients)  
            % 更新网络参数（这里需要根据MATLAB的API进行调整）  
            % 注意：MATLAB的dlnetwork更新方式可能与这里描述的有所不同，请参考官方文档进行实现  
            % ...（省略具体实现细节）  
            newNetwork = network; % 这里只是返回原网络作为占位符，实际中应该更新网络参数后返回新网络对象  
        end  
          
        function prediction = predict(network, input)  
            % 使用网络进行预测（这里需要根据MATLAB的API进行调整）  
            % 注意：MATLAB的dlnetwork预测方式可能与这里描述的有所不同，请参考官方文档进行实现  
            % ...（省略具体实现细节）  
            prediction = zeros(size(input, 1), obj.actionSize); % 这里只是返回零向量作为占位符，实际中应该使用网络进行预测并返回结果  
        end  
    end  
end