function next_position = findProperPoint_Tofly(now_position,direction,Distance,field_tree,trees)
%% 从当前点now_position出发，沿着方向direction走Distance,到达目的地next_position
% 如果next_position不能到达，则在direction方向附近寻找合适的next_position
if norm(direction) - 1 > 1e-5
    direction = direction/norm(direction);
end
d_X = Distance * direction;
next_position = now_position + d_X;
if Is_AllowedinEnv(next_position,field_tree,trees)
    return
end

% 此时direction需要进行修改
range = [0.01,0.05,0.1,0.2,0.3,0.5,0.7,1,2,3,4,5,6,7,8,9,10];
for i=1:length(range)
    X_rand = -1/2*range(i) + range(i)*rand(100,3);
    for j=1:size(X_rand,1)
        temp_direction = direction + X_rand(j,:);
        temp_direction = temp_direction/norm(temp_direction);
        d_X = Distance * temp_direction;
        next_position = now_position + d_X;
        if Is_AllowedinEnv(next_position,field_tree,trees)
            return
        end
    end
end

% 输出找不到合适可行点
next_position = now_position;
warning("找不到合适飞行点！，故障点位置:")
disp(next_position)
return
end

