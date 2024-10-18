classdef Agent_DDPG_0 < handle
    %% 强化学习实现DDPG算法Agent
    properties
        actorNetwork % 动作网络
        criticNetwork % 价值网络
        targetActorNetwork % 目标动作网络
        targetCriticNetwork % 目标价值网络
        actorOptimizer % 动作网络优化器
        criticOptimizer % 价值网络优化器
        replayBuffer % 回放经验池
        gamma % TD算法中gamma值
        tau % 软更新目标网络时的值
        batchSize % 训练最小批量
    end

    methods
        function obj = Agent_DDPG_0(actorNetwork, criticNetwork, targetActorNetwork, targetCriticNetwork, actorOptimizer, criticOptimizer, replayBuffer, gamma, tau, batchSize)
            % 初始化
            obj.actorNetwork = actorNetwork;
            obj.criticNetwork = criticNetwork;
            obj.targetActorNetwork = targetActorNetwork;
            obj.targetCriticNetwork = targetCriticNetwork;
            obj.actorOptimizer = actorOptimizer;
            obj.criticOptimizer = criticOptimizer;
            obj.replayBuffer = replayBuffer;
            obj.gamma = gamma;
            obj.tau = tau;
            obj.batchSize = batchSize;
        end

        function trainStep(obj, state, action, reward, nextState, done)
            % 存储经验到经验回放缓冲区
            obj.replayBuffer.addExperience(state, action, reward, nextState, done);

            % 从经验回放缓冲区中随机采样一批数据
            batch = obj.replayBuffer.sampleBatch(obj.batchSize);
            states = batch.states;
            actions = batch.actions;
            rewards = batch.rewards;
            nextStates = batch.nextStates;
            terminals = batch.terminals;

            % 计算目标 Q 值
            targetActions = obj.targetActorNetwork.predict(nextStates);
            targetQValues = obj.targetCriticNetwork.predict(nextStates, targetActions);
            targetQValues(terminals) = 0;  % 如果是终止状态，目标 Q 值为 0
            targets = rewards + obj.gamma * targetQValues;

            % 更新 Critic 网络
            criticLoss = obj.updateCritic(states, actions, targets);

            % 更新 Actor 网络
            actorLoss = obj.updateActor(states);

            % 更新目标网络
            obj.softUpdateTargets();

            disp(['Critic Loss: ', num2str(criticLoss), ', Actor Loss: ', num2str(actorLoss)]);
        end

        function loss = updateCritic(obj, states, actions, targets)
            currentQValues = obj.criticNetwork.predict(states, actions);
            loss = mse(currentQValues, targets);

            % 反向传播并更新 Critic 网络参数
            obj.criticOptimizer.update(loss);
        end

        function loss = updateActor(obj, states)
            % 使用 Actor 网络预测动作
            predictedActions = obj.actorNetwork.predict(states);

            % 计算 Actor 梯度
            criticGradients = obj.criticNetwork.computeGradients(states, predictedActions);
            actorGradients = obj.actorNetwork.computeGradients(states, criticGradients);

            % 反向传播并更新 Actor 网络参数
            obj.actorOptimizer.update(actorGradients);

            % 返回 Actor 损失
            loss = -mean(criticGradients .* predictedActions);
        end

        function softUpdateTargets(obj)
            % 软更新目标网络参数
            obj.targetActorNetwork.updateWeights(obj.actorNetwork.getWeights(), obj.tau);
            obj.targetCriticNetwork.updateWeights(obj.criticNetwork.getWeights(), obj.tau);
        end
    end
end

function result = mse(x, y)
    % 均方误差损失函数
    result = mean((x - y).^2);
end
