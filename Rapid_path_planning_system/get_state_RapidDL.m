function [state,state_raw] = get_state_RapidDL(point,target,uav_0,max_distance,trees,field_tree)
%% 状态函数设计，应用与无人机强化学习目标路径规划，快速强化学习算法
% trees：导入的树木环境
% field_tree：导入的场地环境
% max_distance：侦察最远距离
% point：待获取状态的点
% target：目标点
try
    directions_all = evalin('base', 'directions_all');
catch
    % 获取待前进方向
    fprintf("在工作区生成方向向量")
    theta = [pi/12, pi/6, pi/4];
    k_numofline = 24;
    numofline = k_numofline * sin(theta);
    numofline = ceil(numofline);
    directions = [0,0,1;
        0,0,-1;
        0,1,0;
        0,-1,0;
        1,0,0;
        -1,0,0];
    directions_all = [];
    for i=1:size(directions,1)
        directions_all = [directions_all;directions(i,:)];
        for j=1:length(theta)
            unitVectors = generateUnitVectors(directions(i,:), theta(j), numofline(j));
            directions_all = [directions_all;unitVectors];
        end
    end
    assignin("base","directions_all",directions_all);
end

direction_target = (target - point)/(norm(target - point)+eps);
directions_all = [directions_all;direction_target];
state = zeros(1, size(directions_all, 1));
% 获取单位前进距离
dX = uav_0.speed(end,:) * uav_0.dt;
for i=1:size(directions_all,1)
    temp_point = point+dX*directions_all(i,:);
    temp_num = 1;
    while Is_AllowedinEnv(temp_point,field_tree,trees) && temp_num*dX <= max_distance
        temp_point = temp_point + dX*directions_all(i,:);
        temp_num = temp_num + 1;
    end
    state(i)=temp_num*dX;
end
% 缩放到0-1
state_raw = state;
if max(state) > 0 
    state = state/max(state);
end
