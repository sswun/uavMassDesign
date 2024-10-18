function state = get_state(point,target,trees,field_tree,uav_0)
%% 状态函数设计，应用与无人机强化学习目标路径规划
% trees：导入的树木环境
% field_tree：导入的场地环境
% uav_0：导入无人机，获取无人机单位时间内运动的距离
% point：待获取状态的点
% target：目标点


% 获取待前进方向
directions = get_all_directions(3);
% 获取单位前进距离
dX = uav_0.speed(end,:) * uav_0.dt;
points = [];
for i=1:size(directions,1)
    temp_point = point + dX*directions(i,:);
    points = [points;temp_point];
end

% 获取各点状态
caninEnv = zeros(1,size(points,1));
dist = caninEnv;
for i=1:size(points,1)
    dist(i) = norm(points(i,:) - target);
    if Is_AllowedinEnv(points(i,:),field_tree,trees)
        caninEnv(i) = 1;
    end
end
max_dist = max(dist);
min_dist = min(dist);
dist = (dist - min_dist)/(max_dist - min_dist);
state = [caninEnv,dist]; % 获取最终状态
end

