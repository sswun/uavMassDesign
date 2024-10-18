%% 检测无人机飞行路径中识别到的燃烧树木数量以及燃烧树木识别率
% 燃烧树木识别率=识别到达燃烧树木/总的燃烧树木
function [positions_burn,positions_recognized,rate] = Tree_burn_recognized(trees,uav_0)
positions_burn = [];
for i=1:length(trees)
    if trees(i).state >= 1
        positions_burn = [positions_burn;trees(i).position(1:2)];
    end
end
temp_check = zeros(size(positions_burn,1),1);
positions_recognized = [];
for i=1:size(uav_0.position,1)
    for j=1:size(positions_burn,1)
        if norm(uav_0.position(i,1:2) - positions_burn(j,:)) < uav_0.max_range
            if temp_check(j) == 0
                positions_recognized = [positions_recognized;positions_burn(j,:)];
                temp_check(j) = 1;
                break
            end
        end
    end
end
rate = size(positions_recognized,1)/size(positions_burn,1);
end

