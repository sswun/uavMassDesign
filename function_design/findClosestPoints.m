function [closestPoints] = findClosestPoints(points, refer)  
    % 输入：  
    % points - 一个 Nx3 矩阵，每行表示一个三维点的坐标  
      
    % 输出：  
    % closestPoints - 一个 Nx3x3 矩阵，每行的三个3D点表示与对应输入点最近的三个点  
      
    numPoints = size(refer, 1);  
    closestPoints = zeros(numPoints, 3, 3); % 初始化输出矩阵  
      
    for i = 1:numPoints  
        % 计算当前点与所有点之间的距离 
        if size(refer, 2) == 2
            distances = sqrt(sum((points(:,1:2) - refer(i, :)).^2, 2)); 
        else
            distances = sqrt(sum((points - refer(i, :)).^2, 2)); 
        end
          
        % 对距离进行排序，并获得索引  
        [~, sortedIndices] = sort(distances);  
          
        % 记录最近的三个点的索引（包括自身）  
        nearestIndices = sortedIndices(1:3);  
          
        % 存储最近的三个点的坐标  
        closestPoints(i, :, :) = points(nearestIndices, :);  
    end  
end