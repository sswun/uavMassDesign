%% 生成point点附近range范围内可存在于环境中的一些点
function point_cho = generatePossiblepointinRange(point,field_tree,trees,range,num_max)
point_cho = [];
temp_check = 0;
while true
    temp_points = -range/2 + range*rand(1000,3);
    for i=1:size(temp_points,1)
        temp_points(i,:) = temp_points(i,:) + point;
    end
    for i=1:size(temp_points,1)
        if Is_AllowedinEnv(temp_points(i,:),field_tree,trees)
            point_cho = [point_cho;temp_points(i,:)];
            if size(point_cho,1) >= num_max
                return
            end
        end
    end
    temp_check = temp_check+1;
    if temp_check > 100
        if isempty(temp_check)
            warning("range范围中可能不存在合适的点")
            point_cho = [];
            return
        else
            return
        end
    end
end
end

