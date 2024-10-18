function [coverageRate, redundancyRate] = calculateCoverageAndRedundancy(polygon, path, radius)
    % polygon: 凸多边形顶点坐标，n x 2 矩阵
    % path: 无人机路径坐标，m x 2 矩阵
    % radius: 无人机搜索半径，标量
    warning('off', 'all');
    % 创建多边形对象
    polyShape = polyshape(polygon(:,1), polygon(:,2));

    % 计算凸多边形总面积
    totalPolygonArea = area(polyShape);

    % 初始化搜索区域
    searchArea = polyshape();

    % 生成搜索区域
    for i = 1:size(path, 1)
        % 生成一个圆形代表无人机在当前位置的搜索区域
        theta = linspace(0, 2*pi, 10)';
        circle = [radius * cos(theta) + path(i, 1), radius * sin(theta) + path(i, 2)];
        circleShape = polyshape(circle);

        % 合并搜索区域
        searchArea = union(searchArea, circleShape);
    end

    % 计算搜索区域与多边形的交集面积
    intersectionArea = area(intersect(searchArea, polyShape));

    % 计算覆盖率
    coverageRate = intersectionArea / totalPolygonArea;

    % 计算总搜索区域面积
    totalSearchArea = area(searchArea);

    % 计算重复率
    redundancyRate = 1 - (intersectionArea / totalSearchArea);
    warning('on', 'all');
end