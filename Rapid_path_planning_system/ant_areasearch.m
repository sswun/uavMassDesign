classdef ant_areasearch < ant
    properties
        alpha_t = 2
        beta_t = 2
        softfun = @(x)4*(x-0.5).^3+0.5
        distance = 0
    end
    methods
        function obj = t_para_set(obj,alpha_t,beta_t)
            % 将之前的alpha，beta参数看做探索者的参数，则此处需要更新运输者的参数
            % alpha_t,beta_t
            obj.alpha_t = alpha_t;
            obj.beta_t = beta_t;
        end
        function obj = go(obj,allow,tao,dist)
            % 标准蚁群算法：
            % allow用来判断蚂蚁从当前位置可以前往什么位置
            % tao为信息素浓度矩阵
            % dist为距离矩阵
            % allow，tao，dist具有相同的形状

            % 注意：此处添加了一条返回语句，意思是如果蚂蚁已经到终点就不再走了
            if obj.positions(end) == allow(end,end)
                return
            end

            temp_positions = allow(:,1);
            if isempty(obj.positions)
                obj.positions = temp_positions(randperm(numel(temp_positions),1));
                warning("未设置初始位置，本次将设置初始位置")
                return
            end
            temp_tobechoosen = allow(obj.positions(end),:);
            probility = tao(obj.positions(end),:).^obj.alpha.*(1./dist(obj.positions(end),:).*obj.beta);
            if sum(probility) <= 0
                temp_point1 = obj.positions(end);
                temp_point2 = temp_tobechoosen(randperm(numel(temp_tobechoosen),1));
                obj.positions = [obj.positions;temp_point2];
                obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
                return
            end
            probility = probility/sum(probility);
            temp_point1 = obj.positions(end);
            temp_point2 = allow(temp_point1,randchoose_accordtoP(probility));
            obj.positions = [obj.positions;temp_point2];
            obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
            return
        end

        function obj = go_e(obj,allow,tao_e,dist,vs)
            % allow用来判断蚂蚁从当前位置可以前往什么位置
            % tao为信息素浓度矩阵
            % dist为距离矩阵
            % vs为探索者随机选择路径阈值
            % allow，tao，dist具有相同的形状

            % 注意：此处添加了一条返回语句，意思是如果蚂蚁已经到终点就不再走了
            if obj.positions(end) == allow(end,end)
                return
            end

            temp_positions = allow(:,1);
            if isempty(obj.positions)
                obj.positions = temp_positions(randperm(numel(temp_positions),1));
                warning("未设置初始位置，本次将设置初始位置")
                return
            end
            temp_tobechoosen = allow(obj.positions(end),:);
            probility = tao_e(obj.positions(end),:).^obj.alpha.*(1./dist(obj.positions(end),:).*obj.beta);
            if sum(probility) <= 0 || rand() < vs
                temp_point1 = obj.positions(end);
                temp_point2 = temp_tobechoosen(randperm(numel(temp_tobechoosen),1));
                obj.positions = [obj.positions;temp_point2];
                obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
                return
            end
            probility = obj.softfun(probility);
            probility = probility/sum(probility);
            temp_point1 = obj.positions(end);
            temp_point2 = allow(temp_point1,randchoose_accordtoP(probility));
            obj.positions = [obj.positions;temp_point2];
            obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
            return
        end

        function obj = go_t(obj,allow,tao_e,tao_t,dist,n)
            % allow用来判断蚂蚁从当前位置可以前往什么位置
            % tao_e为探索者信息素浓度矩阵
            % tao_t为运输者信息素浓度矩阵
            % dist为距离矩阵
            % n为理论中探索者发现较好的几条路径
            % allow，tao_e，tao_t，dist具有相同的形状

            % 注意：此处添加了一条返回语句，意思是如果蚂蚁已经到终点就不再走了
            if obj.positions(end) == allow(end,end)
                return
            end
            
            temp_positions = allow(:,1);
            if isempty(obj.positions)
                obj.positions = temp_positions(randperm(numel(temp_positions),1));
                warning("未设置初始位置，本次将设置初始位置")
                return
            end
            temp_tobechoosen = allow(obj.positions(end),:);
            if n >= length(temp_tobechoosen) || n <= 0
                probility = tao_t(obj.positions(end),:).^obj.alpha_t.*(1./dist(obj.positions(end),:).*obj.beta_t);
                if sum(probility) <= 0
                    temp_point1 = obj.positions(end);
                    temp_point2 = temp_tobechoosen(randperm(numel(temp_tobechoosen),1));
                    obj.positions = [obj.positions;temp_point2];
                    obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
                    return
                end
                probility = obj.softfun(probility);
                probility = probility/sum(probility);
                temp_point1 = obj.positions(end);
                temp_point2 = allow(temp_point1,randchoose_accordtoP(probility));
                obj.positions = [obj.positions;temp_point2];
                obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
                return
            else
                probility_e = tao_e(obj.positions(end),:).^obj.alpha.*(1./dist(obj.positions(end),:).*obj.beta);
                probility = tao_t(obj.positions(end),:).^obj.alpha_t.*(1./dist(obj.positions(end),:).*obj.beta_t);
                if sum(probility) <= 0
                    temp_point1 = obj.positions(end);
                    temp_point2 = temp_tobechoosen(randperm(numel(temp_tobechoosen),1));
                    obj.positions = [obj.positions;temp_point2];
                    obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
                    return
                end
                temp_indices = findMinIndices(probility_e,n-length(temp_tobechoosen));
                probility(temp_indices) = 0;
                probility = obj.softfun(probility);
                probility = probility/sum(probility);
                temp_point1 = obj.positions(end);
                temp_point2 = allow(temp_point1,randchoose_accordtoP(probility));
                obj.positions = [obj.positions;temp_point2];
                obj.distance = obj.distance + dist(temp_point1,findFirstElementValue(allow(temp_point1,:),temp_point2));
            end
        end
    end
end

