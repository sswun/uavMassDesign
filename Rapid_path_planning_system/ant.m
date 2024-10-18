classdef (Abstract) ant
    % 改进蚁群算法中，蚂蚁类的设计
    properties
        type % 蚂蚁的种类
        positions % 蚂蚁行径的位置
        alpha % 信息素浓度因子
        beta % 路径长度决定因子
    end
    
    methods
        % 初始化
        function obj = ant(type,positions,alpha,beta)
            obj.type = type;
            obj.positions = positions;
            obj.alpha = alpha;
            obj.beta = beta;
        end
        % 参数设置
        function obj = set(obj,type,positions,alpha,beta)
            if ~isempty(type)
                obj.type = type;
            end
            if ~isempty(positions)
                obj.positions = positions;
            end
            if ~isempty(alpha)
                obj.alpha = alpha;
            end
            if ~isempty(beta)
                obj.beta = beta;
            end
        end
    end
    methods (Abstract)
       go(obj)
    end
end

