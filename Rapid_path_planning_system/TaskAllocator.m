classdef TaskAllocator  
    % 多无人机任务智能分配
    properties    
        targetPoints; % 存储目标点的数组  
        numofUAVs; % 无人机数量
        dataforAllocator; % 收集用于任务分配的数据
        dimsofdata; % 任务分配数据的维度
    end  
      
    methods  
        function obj = TaskAllocator(targetPoints, numofUAVs, dimsofdata)  
            % 初始化
            obj.numofUAVs = numofUAVs;  
            obj.targetPoints = targetPoints;  
            obj.dimsofdata = dimsofdata;
            if dimsofdata > 1
                obj.dataforAllocator = zeros(numofUAVs, size(targetPoints, 1), dimsofdata);
            else
                obj.dataforAllocator = zeros(numofUAVs, size(targetPoints, 1));
            end
        end  
          
        function assignment = allocateTasks(obj, evaFun, uavs, power_alert)
            % 任务分配，传入的evaFun为评价函数，用于任务分配评价
            assignment = zeros(size(obj.targetPoints, 1), 1);
            for i=1:size(obj.targetPoints, 1)
                temp_eva = zeros(1, obj.numofUAVs);
                index = 1;
                temp_data = 1e10;  % 设置一个较大数
                for j=1:obj.numofUAVs
                    temp_eva(j)=evaFun(obj.dataforAllocator(j,i,:));
                    if temp_data > temp_eva(j) && uavs(j).power(end) > power_alert
                        temp_data = temp_eva(j);
                        index = j;
                    end
                end
                assignment(i)=index;
            end
        end  

        function obj = dataforAllocator_init(obj, uavs)
            % 利用欧氏距离初始化数据
            for i=1:obj.numofUAVs
                for j=1:size(obj.targetPoints, 1)
                    obj.dataforAllocator(i,j,1) = norm(uavs(i).position(end,:)-obj.targetPoints(j,:));
                end
            end
        end

        function obj = dataforAllocator_refresh(obj, i, j, data)
            % 更新data
            obj.dataforAllocator(i,j,:)=data;
        end
    end  
end