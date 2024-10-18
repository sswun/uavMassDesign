function [reward,done] = get_reward(pre_position,now_position,target,field_tree,trees,uav_0)
%% 奖励函数设计，应用与无人机强化学习目标路径规划
% trees：导入的树木环境
% field_tree：导入的场地环境
% uav_0：导入无人机，获取无人机单位时间内运动的距离
% pre_position：之前位置
% now_position：现在位置
% target：目标位置

% 奖励值设置
reward_hit = -1; % 撞机奖励
reward_intarget = 1;  % 到达目标点奖励
reward_closer = 0.1;  % 距离目标点更近的奖励
reward_farther = -0.1;  % 距离目标点更远的奖励

if ~Is_AllowedinEnv(now_position,field_tree,trees)
    reward = reward_hit;
    done = 1;
    return
end

if norm(now_position - target) < uav_0.speed*uav_0.dt
    reward = reward_intarget;
    done = 1;
    return
end

if norm(now_position - target) < norm(pre_position - target)
    reward = reward_closer;
    done = 0;
    return
else
    reward = reward_farther;
    done = 0;
    return
end

end

