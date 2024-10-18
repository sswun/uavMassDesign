%% 定义区域类
classdef region
    %% 定义区域属性
    properties
        profile;% 区域轮廓
        points_for_drone;% 将区域网格化化供无人机飞行覆盖，存储点的位置
        r_scope;% 无人机搜索半径
    end
    %% 区域功能
    methods
        % 初始化
        function obj=region(prof,r_s)
            obj.profile=prof;
            obj.r_scope=r_s;
            obj.points_for_drone=nan;% 先不进行区域离散化
        end
        function obj=region_init(obj,prof,r_s)
            obj.profile=prof;
            obj.r_scope=r_s;
            obj.points_for_drone=nan;% 先不进行区域离散化
        end
        % 判断是否在区域中
        function judgment=is_in_region(obj,point)
            point_clonemove1=[point(1)+1e5,point(2)+113.5];% 注意，此处将横坐标加上
            % 一个较大的数，可以视该线段为射线
            point_clonemove2=[point(1)+1e5,point(2)+1423];
            sizeofprofile=size(obj.profile);
            if(sizeofprofile(1)<3)
                warning("size of profile wrong!")
                judgment=false;
                return
            end
            if(sizeofprofile(2)~=2)
                warning("size of profile wrong!")
                judgment=false;
                return
            end
            % 当point点在多边形顶点位置时，返回true
            for i=1:sizeofprofile(1)
                if(point(1)==obj.profile(i,1))
                    if(point(2)==obj.profile(i,2))
                        judgment=true;
                        return
                    end
                end
            end
            % 注意，由于射线经过多边形顶点时会出现误判情况，此处进行两次判断
            % 第一次判断
            numofintsection1=0;
            for i=1:sizeofprofile(1)
                if(i==sizeofprofile(1))
                    if(is_between_four_points(obj.profile(i,:),...
                            obj.profile(1,:),point,point_clonemove1))
                        numofintsection1=numofintsection1+1;
                    end
                else
                    if(is_between_four_points(obj.profile(i,:),...
                            obj.profile(i+1,:),point,point_clonemove1))
                        numofintsection1=numofintsection1+1;
                    end
                end
            end
            if(mod(numofintsection1,2)~=0)
                judgment=true;
                return
            end
            % 第二次判断
            numofintsection1=0;
            for i=1:sizeofprofile(1)
                if(i==sizeofprofile(1))
                    if(is_between_four_points(obj.profile(i,:),...
                            obj.profile(1,:),point,point_clonemove2))
                        numofintsection1=numofintsection1+1;
                    end
                else
                    if(is_between_four_points(obj.profile(i,:),...
                            obj.profile(i+1,:),point,point_clonemove2))
                        numofintsection1=numofintsection1+1;
                    end
                end
            end
            if(mod(numofintsection1,2)~=0)
                judgment=true;
                return
            end
            judgment=false;
            return
        end
        % 区域离散化
        function obj=region_meshing(obj)
            xmin=obj.profile(1,1);
            xmax=xmin;
            ymin=obj.profile(1,2);
            ymax=ymin;
            sizeofprofile=size(obj.profile);
            if(sizeofprofile(1)<3)
                warning("size of profile wrong!")
                return
            end
            if(sizeofprofile(2)~=2)
                warning("size of profile wrong!")
                return
            end
            for i=1:sizeofprofile(1)
                if(xmin>obj.profile(i,1))
                    xmin=obj.profile(i,1);
                end
                if(xmax<obj.profile(i,1))
                    xmax=obj.profile(i,1);
                end
                if(ymin>obj.profile(i,2))
                    ymin=obj.profile(i,2);
                end
                if(ymax<obj.profile(i,2))
                    ymax=obj.profile(i,2);
                end
            end
            dofgrid=obj.r_scope*sqrt(2)/2;
            x_grid=xmin+dofgrid/2:dofgrid:xmax;
            y_grid=ymin+dofgrid/2:dofgrid:ymax;
            points=[];
            for i=x_grid
                for j=y_grid
                    points=[points;[i,j]];
                end
            end
            if(size(points,1)==0)
                warning("the profile can not grid!")
                return
            end
            obj.points_for_drone=[];
            for i=1:size(points,1)
                if(obj.is_in_region(points(i,:)))
                    obj.points_for_drone=[obj.points_for_drone;points(i,:)];
                end
            end
        end
        % 区域展示
        function region_show(obj)
            figure
            plot([obj.profile(:,1);obj.profile(1,1)],...
                [obj.profile(:,2);obj.profile(1,2)],'b')
            if(~isnan(obj.points_for_drone))
                if(size(obj.points_for_drone,1)~=0)
                    hold on
                    scatter(obj.points_for_drone(:,1),obj.points_for_drone(:,2),'blue')
                    hold off
                end
            end
        end
    end
end
    