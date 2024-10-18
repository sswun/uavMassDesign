classdef tree
    % 树类：用于森林火灾救援任务的设计
    % 树的属性有：
    % 体积量:0~1，代表树的体积信息；
    % 状态：未燃烧0、燃烧1、燃烧且为着火点2；
    % 位置点信息：[x,y,z]，代表树的最低点所在位置坐标，用于无人机检测时位置信息判断
    
    properties
        volume = []
        state = [] % 初始化时，该值为0,1,2时初始化为树，否则初始化为其他形状(3初始化为长方体或球体)
        position = []
        height = []
        % 位置判断时参数
        position_toppart = []
        position_bottompart = []
        radius_toppart = []
        radius_bottompart = []
        % 注意该量为树的标准值，代表树的最大高度
        height_standrad = 20;
        % 形状设置（除了球体加圆柱体的树形状设置，还可以设置长方体、球体等形状）
        shape=[]
    end
    
    methods
        % 初始化
        function obj = tree(volume, state, position)
            if state == 0 || state == 1 || state == 2
                % 初始化为树
                if volume < 0 || volume > 1
                    if volume < 0
                        obj.volume = 0;
                    else
                        obj.volume = 1;
                    end
                else
                    obj.volume = volume;
                end
                if state ~= 0 && state ~= 1 && state ~= 2
                    obj.state = 0;
                else
                    obj.state = state;
                end
                obj.position = position;
                % 计算属性的参数更新
                obj.height = obj.height_standrad * obj.volume;
                obj.position_toppart = obj.position;
                obj.position_toppart(3) = obj.position_toppart(3) + 3*obj.height/4;
                obj.position_bottompart = obj.position;
                obj.position_bottompart(3) = obj.position_bottompart(3) + obj.height/2;
                obj.radius_bottompart = obj.height/4;
                obj.radius_toppart = obj.height/2;
                obj.shape = "树";
            elseif state == 3 || state == 4
                % 初始化为长方体或球体，此时position代表中心位置，volume代表[x,y,z]方向上长度
                obj.position = position;
                obj.volume = volume;
                if state == 3
                    obj.shape = "长方体";
                else
                    obj.shape = "球体(或椭球体)";
                end
                obj.state = state;
            end
        end

        % 设置参数
        function obj = set(obj, volume, state, position)
            if state == 0 || state == 1 || state == 2
                % 初始化为树
                if volume < 0 || volume > 1
                    if volume < 0
                        obj.volume = 0;
                    else
                        obj.volume = 1;
                    end
                else
                    obj.volume = volume;
                end
                if state ~= 0 && state ~= 1 && state ~= 2
                    obj.state = 0;
                else
                    obj.state = state;
                end
                obj.position = position;
                % 计算属性的参数更新
                obj.height = obj.height_standrad * obj.volume;
                obj.position_toppart = obj.position;
                obj.position_toppart(3) = obj.position_toppart(3) + 3*obj.height/4;
                obj.position_bottompart = obj.position;
                obj.position_bottompart(3) = obj.position_bottompart(3) + obj.height/2;
                obj.radius_bottompart = obj.height/4;
                obj.radius_toppart = obj.height/2;
                obj.shape = "树";
            elseif state == 3 || state == 4
                % 初始化为长方体或球体，此时position代表中心位置，volume代表[x,y,z]方向上长度
                obj.position = position;
                obj.volume = volume;
                if state == 3
                    obj.shape = "长方体";
                else
                    obj.shape = "球体(或椭球体)";
                end
                obj.state = state;
            end
        end
        
        % 判断某点是否处在树内部还是树外部
        function isintree = isintree_point(obj,point_totest)
            if obj.state == 0 || obj.state == 1 || obj.state == 2
                % 形状为树的情况
                if norm(point_totest - obj.position_toppart) < obj.radius_toppart
                    isintree = true;
                    return
                elseif point_totest(3) > obj.position(3) && point_totest(3) < obj.position_bottompart(3)
                    if norm(point_totest(1:2) - obj.position(1:2)) < obj.radius_bottompart
                        isintree = true;
                        return
                    end
                end
            elseif obj.state == 3
                % 形状为长方体的情况
                lowerBound = obj.position - 0.5*obj.volume;
                upperBound = obj.position + 0.5*obj.volume;
                for i=1:length(lowerBound)
                    if point_totest(i) < lowerBound(i)
                        isintree = false;
                        return
                    elseif point_totest(i) > upperBound(i)
                        isintree = false;
                        return
                    end
                end
                isintree = true;
                return
            elseif obj.state == 4
                % 形状为球体的情况
                temp = (point_totest - obj.position).^2;
                temp = sum(temp./((obj.volume./2).^2));
                if temp < 1
                    isintree = true;
                    return
                else
                    isintree = false;
                    return
                end
            end
            isintree = false;
            return
        end

        % 其他功能编写位置
    end
end

