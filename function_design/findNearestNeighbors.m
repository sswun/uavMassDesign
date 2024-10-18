%% 输入一个矩阵inputMatrix，其中矩阵每一行代表一个节点，矩阵的列代表节点的坐标，
% 输出一矩阵，该矩阵有k列，输出矩阵每一行代表输入矩阵对应的节点，
% 输出矩阵的列代表与该节点位置最近的k个节点的输入矩阵行下标。
% 其中nearestNeighbors为输出的该矩阵，dist为对应的距离。
function [nearestNeighbors,dist] = findNearestNeighbors(inputMatrix, k)
    numNodes = size(inputMatrix, 1);
    nearestNeighbors = zeros(numNodes, k);
    dist = zeros(numNodes, k);

    for i = 1:numNodes
        % 计算距离
        distances = sum((inputMatrix - inputMatrix(i, :)).^2, 2);
        % 排序并获取最近的k个节点的行下标
        [~, sortedIndices] = sort(distances);
        % 去除自身节点的索引
        sortedIndices = sortedIndices(sortedIndices ~= i);
        % 选择最近的k个节点
        nearestNeighbors(i, :) = sortedIndices(1:k);
        dist(i, :) = sqrt(distances(nearestNeighbors(i, :)))';
    end
end
