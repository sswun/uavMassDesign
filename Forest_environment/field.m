classdef field
    % 场地类：用于森林火灾救援任务的设计
    % 属性：
    % 位置群：positions，代表场地中各个树的位置，为n*3向量，n代表树的个数
    properties
        positions
        % 场地坐标限制
        xmin
        ymin
        xmax
        ymax
        zmax
        temp_positions
    end
    
    methods
        % 初始化
        function obj = field(positions)
            obj.positions = positions;
            obj.xmin = min(obj.positions(:,1));
            obj.xmax = max(obj.positions(:,1));
            obj.ymin = min(obj.positions(:,2));
            obj.ymax = max(obj.positions(:,2));
            obj.zmax = max(obj.positions(:,3))+20;
            obj.temp_positions = positions;
        end

        % 判断是否位于场地下方
        function isunderfield = isunderfield_point(obj,point)
            if point(1) < obj.xmin || point(1) > obj.xmax
                if point(3) > 0
                    isunderfield = false;
                    return
                else
                    isunderfield = true;
                    return
                end
            elseif point(2) < obj.ymin || point(2) > obj.ymax
                if point(3) > 0
                    isunderfield = false;
                    return
                else
                    isunderfield = true;
                    return
                end
            else
                for i=1:3
                    for j=size(obj.temp_positions,1)-1:-1:i
                        if norm(obj.temp_positions(j,1:2) - point(1:2)) > ...
                                norm(obj.temp_positions(j+1,1:2) - point(1:2))
                            temp0 = obj.temp_positions(j,:);
                            obj.temp_positions(j,:) = obj.temp_positions(j+1,:);
                            obj.temp_positions(j+1,:) = temp0;
                        end
                    end
                end
                if ~isPointInTriangle(point(1:2), obj.temp_positions(1:3,1:2))
                    if point(3) > 0
                        isunderfield = false;
                        return
                    else
                        isunderfield = true;
                        return
                    end
                end
                % 当point点高度在该三点之上时，point必不在场地下方，同理，
                % 当point点高度在该三点之下时，point必在场地下方。
                if point(3)>obj.temp_positions(1,3) && point(3)>obj.temp_positions(2,3) && ...
                        point(3)>obj.temp_positions(3,3)
                    isunderfield = false;
                    return
                end
                if point(3)<obj.temp_positions(1,3) && point(3)<obj.temp_positions(2,3) && ...
                        point(3)<obj.temp_positions(3,3)
                    isunderfield = true;
                    return
                end
                relative_position = pointRelativeToTriangle(point,obj.temp_positions(1:3,:));
                if relative_position <= 0
                    isunderfield = true;
                    return
                else
                    isunderfield = false;
                    return
                end
            end
        end
    end
end


