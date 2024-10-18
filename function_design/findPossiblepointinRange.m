%% 输入一个点，判断该点是否可以在环境中，若不能，则在range范围中寻找合适的点
function point_cho = findPossiblepointinRange(point,field_tree,trees,range)
if Is_AllowedinEnv(point,field_tree,trees)
    point_cho = point;
    return
end
temp_check = 0;
while true
    temp_points = -range/2 + range*rand(10,3);
    for i=1:size(temp_points,1)
        temp_points(i,:) = temp_points(i,:) + point;
    end
    for i=1:size(temp_points,1)
        if Is_AllowedinEnv(temp_points(i,:),field_tree,trees)
            point_cho = temp_points(i,:);
            return
        end
    end
    temp_check = temp_check+1;
    if temp_check > 1000
        warning("range范围中可能不存在合适的点")
        point_cho = point;
        return
    end
end
end

