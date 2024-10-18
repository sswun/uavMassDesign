function hullPoints = findConvexHull(points)
    % 检查输入是否是二维点
    if size(points, 2) ~= 2
        error('输入必须是二维点的坐标矩阵');
    end

    % 计算凸包的索引
    k = convhull(points(:, 1), points(:, 2));

    % 提取凸包的点
    hullPoints = points(k, :);
end
