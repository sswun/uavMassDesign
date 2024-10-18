function [uav_1,agent] = Rapid_PP_TPP_IDDPG(uav_0,target,num_prelearn,numtofly,field_tree,trees)
%% 结合改进策略4————改善强化学习训练算法过程，在算法中添加预学习的过程，的强化学习路径规划过程
% num_prelearn = 100;  % 预学习次数
% numtofly = 10;  % 总测试次数
% target = Nodes{1}(40,:);  % 目标位置
action_dim = 3; % 动作维度
state_dim = 54; % 状态维度
batch_size = 40; % 输入最大批量大小
agent = Agent_DDPG_2(action_dim,state_dim);  % 初始化智能体
max_step = 200; % 最大步数
uav_1 = uav_0; % 复制一份无人机
%% 预训练过程
for i=1:num_prelearn
    uav_0.position = uav_1.position(end,:);  % 初始化无人机位置
    state0 = get_state(uav_0.position(end,:),target,trees,field_tree,uav_0);  % 获得无人机初始状态
    done = 0; % 判断是否结束
    sum_reward = 0; % 计算总的回报
    step = 0;
    check = 0;
    while ~done
        step = step+1;
        direction = (target - uav_0.position(end,:))/norm(uav_0.position(end,:) - target);
        d_dist = uav_0.speed(end,:)*uav_0.dt;
        next_position = findProperPoint_Tofly(uav_0.position(end,:),direction,d_dist,...
            field_tree,trees);
        action = (next_position - uav_0.position(end,:))/...
            norm(next_position - uav_0.position(end,:));  % 进行动作
        uav_0 = uav_0.Fly_inDirection(action);  % 无人机进行飞行
        [reward,done] = get_reward(uav_0.position(end-1,:),uav_0.position(end,:),...
            target,field_tree,trees,uav_0);  % 获得奖励
        state1 = get_state(uav_0.position(end,:),target,trees,field_tree,uav_0);
        SARSD = [state0,action,reward,state1,done]; % 获得SARSD序列
        agent = agent.add_experience(SARSD);  % 将该序列添加到经验回访池
        % 更新状态
        state0 = state1;
        sum_reward = sum_reward+reward;
        if ~done
            if step >= max_step
                warning("智能体可能不收敛!")
                check = 1;
            end
        end
        if check == 1
            break
        end
    end
    agent = agent.update_pre(batch_size);  % 更新参数
    fprintf("第%d轮预训练结束，总回报为%f",i,sum_reward)
end

%% 强化学习训练过程
uav_2 = uav_0;
for i=1:numtofly
    uav_2.position = uav_1.position(end,:);  % 初始化无人机位置
    state0 = get_state(uav_2.position(end,:),target,trees,field_tree,uav_2);  % 获得无人机初始状态
    done = 0; % 判断是否结束
    sum_reward = 0; % 计算总的回报
    step = 0;
    check = 0;
    while ~done
        step = step+1;
        action = agent.take_action_addRand(state0);  % 进行动作
        uav_2 = uav_2.Fly_inDirection(action');  % 无人机进行飞行
        [reward,done] = get_reward(uav_2.position(end-1,:),uav_2.position(end,:),...
            target,field_tree,trees,uav_2);  % 获得奖励
        state1 = get_state(uav_2.position(end,:),target,trees,field_tree,uav_2);
        SARSD = [state0,action',reward,state1,done]; % 获得SARSD序列
        agent = agent.add_experience(SARSD);  % 将该序列添加到经验回访池
        % 更新状态
        state0 = state1;
        sum_reward = sum_reward+reward;
        if ~done
            if step >= max_step
                warning("智能体可能不收敛!")
                check = 1;
            end
        end
        if check == 1
            break
        end
    end
    agent = agent.update(batch_size);  % 更新参数
    fprintf("第%d轮训练结束，总回报为%f\n",i,sum_reward)
end

%% 让无人机1按照规划好的路线飞行
if norm(uav_2.position(end,:) - target) < uav_1.speed(end,:)*uav_1.dt
    for i=2:size(uav_2.position,1)
        uav_1 = uav_1.FlyToNextPoint_flexible(uav_2.position(i,:),[],[],trees,field_tree);
    end
    return
end
if norm(uav_0.position(end,:) - target) < uav_1.speed(end,:)*uav_1.dt
    for i=2:size(uav_0.position,1)
        uav_1 = uav_1.FlyToNextPoint_flexible(uav_0.position(i,:),[],[],trees,field_tree);
    end
    return
end
agent = 0;
return
end

