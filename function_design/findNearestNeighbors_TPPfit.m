%% 输入一个矩阵inputMatrix，其中矩阵每一行代表一个节点，矩阵的列代表节点的坐标，
% 输出一矩阵，该矩阵有k列，输出矩阵每一行代表输入矩阵对应的节点，
% 输出矩阵的列代表与该节点位置最近的k个节点的输入矩阵行下标。
% 其中nearestNeighbors为输出的该矩阵，dist为对应的距离。

% 注意，此函数适用于TPP问题（Target path planning）
function [nearestNeighbors,dist] = findNearestNeighbors_TPPfit(inputMatrix, k)
    numNodes = size(inputMatrix, 1);
    nearestNeighbors = zeros(numNodes,k);
    dist = zeros(numNodes,k);
    nearestNeighbors(1,:) = cumsum(ones(1,k))+1;
    for i=2:numNodes
        nearestNeighbors(i,:) = nearestNeighbors(i-1,:) + 1;
    end
    for i=numNodes-k-1:numNodes
        for j=1:k
            if nearestNeighbors(i,j) > numNodes
                nearestNeighbors(i,j) = numNodes;
            end
        end
    end
    for i=1:numNodes
        for j=1:k
            dist(i,j) = norm(inputMatrix(nearestNeighbors(i,j),:) - inputMatrix(i,:));
            if(dist(i,j) == 0)
                dist(i,j) = 1;
            end
        end
    end
end
