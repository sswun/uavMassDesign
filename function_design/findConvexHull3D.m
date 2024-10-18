function hullPoints = findConvexHull3D(points)
    % 检查输入是否是三维点
    if size(points, 2) ~= 3
        error('输入必须是三维点的坐标矩阵');
    end

    % 计算凸包的索引
    K = convhull(points(:, 1), points(:, 2), points(:, 3));

    % 提取凸包的点
    hullPoints = unique(points(K, :), 'rows');
end