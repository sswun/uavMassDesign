function plotSurfaceFromPoints(points)
    % points: n x 3 矩阵，每行代表一个点的坐标 [x, y, z]

    % 检查输入点是否为二维或三维
    if size(points, 2) ~= 3
        error('points 应该是 n x 3 的矩阵，表示每个点的 [x, y, z] 坐标');
    end
    positions_2D = points(:,1:2);
    hullpositions_2D = findConvexHull(positions_2D);
    point_min = min(points);
    point_max = max(points);
    size_field = norm(point_max-point_min);
    r_s = size_field/10; % 半径
    task_region = region(hullpositions_2D(1:end-1,:),r_s);
    task_region = task_region.region_meshing; % 区域离散化
    [closestPoints] = findClosestPoints(points, task_region.points_for_drone);
    
    % 设置视图和标签
    for i=1:size(closestPoints,1)
        vertex1 = [closestPoints(i,1,1), closestPoints(i,1,2), closestPoints(i,1,3)];  
        vertex2 = [closestPoints(i,2,1), closestPoints(i,2,2), closestPoints(i,2,3)];  
        vertex3 = [closestPoints(i,3,1), closestPoints(i,3,2), closestPoints(i,3,3)];  
        fill3([vertex1(1), vertex2(1), vertex3(1)], ...  
          [vertex1(2), vertex2(2), vertex3(2)], ...  
          [vertex1(3), vertex2(3), vertex3(3)], ...  
          'b', 'EdgeColor', 'k'); 
    end
    axis equal;
    grid on;
    view(3);
    % 定义三角形的三个顶点  
end
