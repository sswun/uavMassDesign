function [uav, agent, SA] = fly_ByAgent(uav, agent, target, trees, field_tree, israndom)
% 根据Agent设定的路线进行无人机的飞行
max_distance = 50; % 最大探测范围
state0 = get_state_RapidDL(uav.position(end,:),target,uav,max_distance,trees,field_tree);  % 获得无人机初始状态
done = 0; % 判断是否结束
range = 10; % 目标检测范围
step = 0;
max_step = 500; % 最大步数
check = 0;
SA = [];
while ~done
    step = step+1;
    if israndom
        action = agent.take_action_addRand(state0);  % 进行动作
    else
        action = agent.take_action(state0);
    end
    uav = uav.Fly_inDirection(action');  % 无人机进行飞行
    [~,done] = get_reward_RapidDL(uav.position(end-1,:),uav.position(end,:),...
        target,field_tree,trees,range);  % 判断是否结束
    state1 = get_state_RapidDL(uav.position(end,:),target,uav,max_distance,trees,field_tree);
    % 更新状态
    SA = [SA;[state0,action']];
    state0 = state1;
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
