function pathLength = calculatePathLength(path)
    % path 是一个 n x 3 的矩阵，每行表示无人机的一个三维坐标 [x, y, z]

    % 初始化路径长度
    pathLength = 0;

    % 遍历所有点，计算相邻点之间的距离并累加
    for i = 1:size(path, 1) - 1
        % 计算相邻点之间的欧氏距离
        distance = norm(path(i, :) - path(i + 1, :));
        
        % 累加距离
        pathLength = pathLength + distance;
    end
end