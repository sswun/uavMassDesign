classdef Position_container

    % 位置容器，用于多智能体任务
    properties
        container  % 位置容器
        numofUAV  % 无人机数量
    end
    
    methods
        function obj = Position_container(positions, numofUAV)
            obj.numofUAV = numofUAV;
            % 首先我们利用K—means算法对positions进行划分
            obj.container = cell(numofUAV, 1);
            for i=1:obj.numofUAV
                obj.container{i} = [];
            end
            [cluster_idx, ~] = kmeans(positions, obj.numofUAV, 'distance','sqEuclidean', 'Replicates',3); 
            for i=1:length(cluster_idx)
                obj.container{cluster_idx(i)} = [obj.container{cluster_idx(i)}; positions(i,:)];
            end
        end
        
        function obj = swap_position(obj,ith, jth)
            % 将第ith个位置群中某个位置让给第jth
            positions1 = obj.container{ith};
            positions2 = obj.container{jth};
            % 初始化最小平均距离为无穷大  
            minAvgDistance = inf;  
            closestPosition = [];  
            closestPosition_index = 0;
            % 遍历 positions1 中的每个位置  
            for i = 1:size(positions1, 1)  
                % 计算 positions1 中第 i 个位置与 positions2 中所有位置的距离  
                distances = sqrt(sum((positions2 - positions1(i, :)).^2, 2));  
                % 计算平均距离  
                avgDistance = mean(distances);  
                % 如果当前平均距离小于已知的最小平均距离，则更新最小平均距离和最近位置  
                if avgDistance < minAvgDistance  
                    minAvgDistance = avgDistance;  
                    closestPosition = positions1(i, :);  
                    closestPosition_index = i;
                end  
            end  
            % 将找到的最近位置添加到 positions2 中  
            positions2 = [positions2; closestPosition];
            positions1(closestPosition_index,:) = [];
            obj.container{ith} = positions1;
            obj.container{jth} = positions2;
        end
    end
end

