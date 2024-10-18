function snakePath = generateSnakePath(points)
%% 将点蛇形排列
    % points 是一个 n x 2 的矩阵，每行表示一个二维点 [x, y]

    % 按 x 坐标排序
    sortedPoints = sortrows(points, 1);

    % 找出每个 x 坐标的唯一值
    uniqueX = unique(sortedPoints(:, 1));

    % 初始化蛇形路径
    snakePath = [];

    % 遍历每个唯一的 x 坐标
    for i = 1:length(uniqueX)
        % 提取当前 x 坐标的所有点
        currentXPoints = sortedPoints(sortedPoints(:, 1) == uniqueX(i), :);

        % 按 y 坐标排序
        currentXPoints = sortrows(currentXPoints, 2);

        % 如果是偶数行，逆序排列
        if mod(i, 2) == 0
            currentXPoints = flipud(currentXPoints);
        end

        % 将当前 x 坐标的点添加到蛇形路径中
        snakePath = [snakePath; currentXPoints];
    end
end
