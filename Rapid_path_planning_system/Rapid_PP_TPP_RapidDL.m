function [uav_1,agent,distance_ave,min_distance] = Rapid_PP_TPP_RapidDL(uav_0,target,num_prelearn,numtofly,field_tree,trees)
%% 快速强化学习过程
action_dim = 3; % 动作维度
state_dim = 223; % 状态维度
batch_size = 40; % 输入最大批量大小
agent = Agent_RapidDL(action_dim,state_dim);  % 初始化智能体
max_distance = 50; % 最大探测范围
range = 10; % 目标检测范围
max_step = 500; % 最大步数
uav_1 = uav_0; % 复制一份无人机
distance_check = [];
distance_ave = [];
num_exp = 10; % 经验池存储的上限次数
epochs = 50;
min_distance = 1e10; % 设置一个较大数字
%% 预训练过程
h = waitbar(0, 'Please wait...');
for i=1:num_prelearn
    uav_0.position = uav_1.position(end,:);  % 初始化无人机位置
    state0 = get_state_RapidDL(uav_0.position(end,:),target,uav_0,max_distance,trees,field_tree);  % 获得无人机初始状态
    done = 0; % 判断是否结束
    step = 0;
    all_distance = 0;
    check = 0;
    temp_SA = [];
    while ~done
        step = step+1;
        direction = (target - uav_0.position(end,:))/norm(uav_0.position(end,:) - target);
        d_dist = uav_0.speed(end,:)*uav_0.dt;
        next_position = findProperPoint_Tofly(uav_0.position(end,:),direction,d_dist,...
            field_tree,trees);
        action = (next_position - uav_0.position(end,:))/...
            norm(next_position - uav_0.position(end,:));  % 进行动作
        uav_0 = uav_0.Fly_inDirection(action);  % 无人机进行飞行
        [~,done] = get_reward_RapidDL(uav_0.position(end-1,:),uav_0.position(end,:),...
            target,field_tree,trees,range);  % 判断是否结束
        state1 = get_state_RapidDL(uav_0.position(end,:),target,uav_0,max_distance,trees,field_tree);
        SA = [state0,action]; % 获得SA序列
        temp_SA = [temp_SA;SA];  % 将该序列添加到经验回访池
        % 更新状态
        state0 = state1;
        all_distance = all_distance+d_dist;
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
    if i < num_exp
        agent = agent.add_experience(temp_SA);
        agent = agent.update(batch_size);  % 更新参数
        distance_check = [distance_check;all_distance];
    else
        if all_distance < min_distance
            min_distance = all_distance;
            agent = agent.add_experience(temp_SA);
            agent = agent.pop_experience(size(temp_SA, 1));
            agent = agent.update(batch_size);
            distance_check = [distance_check;all_distance];
        else
            agent = agent.update(batch_size);
        end
    end
    distance_ave = [distance_ave;all_distance];
    waitbar(i / num_prelearn, h, sprintf('Progress: %d%%', floor(100 * i / num_prelearn)));
end
close(h);
distance_ave = mean(distance_ave);
fprintf("预训练过程结束\n")
%% 快速强化学习训练过程
min_distance = mean(distance_check);
uav_2 = uav_0;
h = waitbar(0, 'Please wait...');
for i=1:numtofly
    uav_2.position = uav_1.position(end,:);  % 初始化无人机位置
    state0 = get_state_RapidDL(uav_2.position(end,:),target,uav_2,max_distance,trees,field_tree);  % 获得无人机初始状态
    done = 0; % 判断是否结束
    all_distance = 0; % 计算总的回报
    step = 0;
    check = 0;
    temp_SA = [];
    while ~done
        step = step+1;
        action = agent.take_action_addRand(state0);  % 进行动作
        uav_2 = uav_2.Fly_inDirection(action');  % 无人机进行飞行
        [~,done] = get_reward_RapidDL(uav_2.position(end-1,:),uav_2.position(end,:),...
            target,field_tree,trees,range);  % 判断是否结束
        state1 = get_state_RapidDL(uav_2.position(end,:),target,uav_2,max_distance,trees,field_tree);
        SA = [state0,action']; % 获得SA序列
        temp_SA = [temp_SA;SA];  % 将该序列添加到暂时经验回访池
        % 更新状态
        state0 = state1;
        all_distance = all_distance+d_dist;
        if ~done
            if step >= max_step
                warning("智能体可能不收敛!")
                for train_num = 1:30
                    agent = agent.update(batch_size);  % 更新参数
                end
                check = 1;
            end
        end
        if check == 1
            break
        end
    end
    if all_distance < min_distance && check == 0
        agent = agent.pop_experience(size(temp_SA, 1));
        agent = agent.add_experience(temp_SA);
        for train_num = 1:epochs
            agent = agent.update(batch_size);  % 更新参数
        end
        min_distance = all_distance;
    end
    waitbar(i / numtofly, h, sprintf('Progress: %d%%', floor(100 * i / numtofly)));
end
close(h);
%% 让无人机1按照规划好的路线飞行
if norm(uav_2.position(end,:) - target) < range
    for i=2:size(uav_2.position,1)
        uav_1 = uav_1.FlyToNextPoint_flexible(uav_2.position(i,:),[],[],trees,field_tree);
    end
    return
end
if norm(uav_0.position(end,:) - target) < range
    for i=2:size(uav_0.position,1)
        uav_1 = uav_1.FlyToNextPoint_flexible(uav_0.position(i,:),[],[],trees,field_tree);
    end
    return
end
agent = 0;
return
end

