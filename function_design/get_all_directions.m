function directions = get_all_directions(n_dims)
%% 输入一维度个数，输出对应维度下所有离散方块方向向量
dims = [-1;1;0];
if n_dims == 1
    directions = dims;
    return
end
if n_dims > 1
    directions_raw = get_all_directions(n_dims - 1);
    directions = [];
    for i=1:length(dims)
        temp_directions = [dims(i)*ones(size(directions_raw,1),1),directions_raw];
        directions = [directions;temp_directions];
    end
end
for i=1:size(directions,1)
    if norm(directions(i,:)) ~= 0
        directions(i,:) = directions(i,:)/norm(directions(i,:));
    end
end
end

