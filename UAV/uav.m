classdef uav
    %UAV无人机类设计
    %无人机类属性：
    % max_speed：最大速度；
    % max_range：最大搜索范围；
    % max_altitude：最大高度；
    % max_power：最大电源；
    % max_load：最大负载重量
    % k_up：上升电量消耗
    % k_down：下降电量消耗
    % k_around：平行飞电量消耗
    % dt：模拟飞行时时间微元
    properties
        max_speed
        max_range
        max_altitude
        max_power
        max_load
        k_up
        k_down 
        k_around
        dt
        % 当前无人机所处状态属性
        speed % 速度
        time % 运行时间
        power % 当前电量
        load % 当前负载
        position % 无人机位置变化
    end
    
    methods
        % 初始化
        function obj = uav(max_speed,max_range,max_altitude,max_power,...
                max_load,k_up,k_down,k_around,dt)
            obj.max_speed = max_speed;
            obj.max_range = max_range;
            obj.max_altitude = max_altitude;
            obj.max_power = max_power;
            obj.max_load = max_load;
            obj.k_up = k_up;
            obj.k_down = k_down;
            obj.k_around = k_around;
            obj.dt = dt;
            % 设置当前无人机所处状态属性
            obj.speed = 0;
            obj.time = 0;
            obj.power = obj.max_power;
            obj.load = obj.max_load / 2;
            obj.position = [0,0,0];
        end
        
        % 重设当前无人机所处状态属性
        function obj = current_properties_reset(obj,speed,time,power,load,position)
            % 速度检测更新
            if speed < 0
                error("speed必须大于0")
            elseif speed > obj.max_speed
                error("speed必须小于无人机的最大速度")
            else
                obj.speed = speed;
            end
            % 时间检测更新
            if time < 0
                error("time必须大于0")
            else
                obj.time = time;
            end
            % 电量检测更新
            if power < 0
                error("power必须大于0")
            elseif power > obj.max_power
                error("power必须小于无人机的最大电量")
            else
                obj.power = power;
            end
            % 负载检测更新
            if load < 0
                error("load必须大于0")
            elseif load > obj.max_load
                error("load必须小于无人机的最大负载")
            else
                obj.load = load;
            end
            obj.position = position;
        end

        % 无人机在运行时，添加当前无人机所处状态属性
        function obj = current_properties_add(obj,speed,time,power,load,position)
            % 速度检测更新
            if speed < 0
                error("speed必须大于0")
            elseif speed > obj.max_speed
                error("speed必须小于无人机的最大速度")
            else
                obj.speed = [obj.speed;speed];
            end
            % 时间检测更新
            if time < 0
                error("time必须大于0")
            else
                obj.time = [obj.time;time];
            end
            % 电量检测更新
            if power < 0
                error("power必须大于0")
            elseif power > obj.max_power
                error("power必须小于无人机的最大电量")
            else
                obj.power = [obj.power;power];
            end
            % 负载检测更新
            if load < 0
                error("load必须大于0")
            elseif load > obj.max_load
                error("load必须小于无人机的最大负载")
            else
                obj.load = [obj.load;load];
            end
            obj.position = [obj.position;position];
        end

        % 检测某点是否无法到达
        function isreachable = isreachable_point(obj,point_toreach,envobstcale)
            if isempty(point_toreach)
                point_toreach = obj.position(end,:);
            end
            if isa(envobstcale,"field")
                for i=1:size(envobstcale,1)
                    if envobstcale(i).isunderfield_point(point_toreach)
                        isreachable = false;
                        return
                    end
                end
                isreachable = true;
                return
            elseif isa(envobstcale,"tree")
                for i=1:size(envobstcale,1)
                    if envobstcale(i).isintree_point(point_toreach)
                        isreachable = false;
                        return
                    end
                end
                isreachable = true;
            else
                isreachable = true;
            end
        end

        % 无人机忽略环境，忽略损耗向某一方向飞行
        function obj = Fly_inDirection(obj,direction)
            if norm(direction) < 1e-9
                return
            elseif norm(direction) > 1 || norm(direction) < 1
                direction = direction/norm(direction);
            end
            d_dist = obj.speed*obj.dt; % 每一个dt时段内飞行的路程
            next_position = obj.position(end,:) + d_dist*direction;
            obj.position = [obj.position;next_position];
        end

        % 无人机以速度speed从当前点出发前往下一个点
        function obj = FlyToNextPoint(obj,point_next,speed,load,obstacle_tree,obstacle_field)
            % 飞行合理性检验
            if isempty(speed)
                speed = obj.speed(end);
            end
            if isempty(load)
                load = obj.load(end);
            end
            if speed < 0
                error("speed必须大于0")
            elseif speed > obj.max_speed
                error("speed必须小于无人机的最大速度")
            end
            if load < 0
                error("load必须大于0")
            elseif load > obj.max_load
                error("load必须小于无人机的最大负载")
            end
            if point_next(3) > obj.max_altitude
                error("无人机要到达的地方海拔太高！")
            end
            if norm(point_next - obj.position(end,:)) < 1e-5
                warning("当前前往点距离当前点太近，无人机不运行！故障点位置：")
                disp(point_next)
                return
            end
            if ~(obj.isreachable_point(point_next,obstacle_tree) && ...
                    obj.isreachable_point(point_next,obstacle_field))
                warning("无人机无法到达当前点!故障点位置：")
                disp(point_next)
                return
            end
            % 进行飞行
            distance = norm(point_next - obj.position(end,:));
            pointtopoint = point_next - obj.position(end,:);
            time_tofly = distance / speed;
            times_tofly = ceil(time_tofly / obj.dt); % 飞行次数，每次飞行dt时间
            dx_fly = pointtopoint / times_tofly;
            consum = 0;
            if pointtopoint(3) > 0
                consum = consum + obj.k_up*obj.load*pointtopoint(3);
            elseif pointtopoint(3) < 0
                consum = consum - obj.k_down*obj.load*pointtopoint(3);
            end
            consum = consum + obj.k_around*obj.load*sqrt(distance^2 - pointtopoint(3)^2);
            dconsum = consum/times_tofly;
            for i=1:times_tofly
                obj.speed = [obj.speed;speed];
                obj.time = [obj.time;obj.time(end)+obj.dt];
                obj.power = [obj.power;obj.power(end,:)-dconsum(1)];
                obj.load = [obj.load;load];
                obj.position = [obj.position;obj.position(end,:)+dx_fly];
                % 检验合理性
                if obj.power(end) < 0
                    warning("无人机电量耗尽！")
                    obj.speed(end,:) = [];
                    obj.time(end,:) = [];
                    obj.power(end,:) = [];
                    obj.load(end,:) = [];
                    obj.position(end,:) = [];
                    return
                end
                if ~(obj.isreachable_point(obj.position(end,:),obstacle_tree) &&...
                        obj.isreachable_point(obj.position(end,:),obstacle_field))
                    warning("遇到障碍物！，故障点位置：")
                    disp(obj.position(end,:))
                    obj.speed(end,:) = [];
                    obj.time(end,:) = [];
                    obj.power(end,:) = [];
                    obj.load(end,:) = [];
                    obj.position(end,:) = [];
                    return
                end
            end
        end

        % 无人机以速度speed从当前点出发前往下一个点，当遇到障碍物时，会尝试灵活的绕过障碍物前进
        function obj = FlyToNextPoint_flexible(obj,point_next,speed,load,obstacle_tree,obstacle_field)
            % 飞行合理性检验
            if isempty(speed)
                speed = obj.speed(end);
            end
            if isempty(load)
                load = obj.load(end);
            end
            if speed < 0
                error("speed必须大于0")
            elseif speed > obj.max_speed
                error("speed必须小于无人机的最大速度")
            end
            if load < 0
                error("load必须大于0")
            elseif load > obj.max_load
                error("load必须小于无人机的最大负载")
            end
            if point_next(3) > obj.max_altitude
                error("无人机要到达的地方海拔太高！")
            end
            if norm(point_next - obj.position(end,:)) < 1e-5
                warning("当前前往点距离当前点太近，无人机不运行！故障点位置：")
                disp(point_next)
                return
            end
            if ~(obj.isreachable_point(point_next,obstacle_tree) && ...
                    obj.isreachable_point(point_next,obstacle_field))
                warning("无人机无法到达当前点!故障点位置：")
                disp(point_next)
                return
            end
            % 进行飞行
            d_dist = speed*obj.dt; % 每一个dt时段内飞行的路程
            now_position = obj.position(end,:); % 当前无人机位置
            while norm(now_position - point_next) > d_dist
                % 开始迭代飞行过程
                direction = (point_next - now_position)/norm(now_position - point_next);
                next_position = findProperPoint_Tofly(now_position,direction,d_dist,...
                    obstacle_field,obstacle_tree);
                if next_position(1) == now_position(1) && ...
                        next_position(2) == now_position(2) && ...
                        next_position(3) == now_position(3)
                    return
                end
                % 更新参数
                obj.speed = [obj.speed;speed];
                obj.time = [obj.time;obj.time(end)+obj.dt];
                obj.load = [obj.load;load];
                temp_X_change = next_position - now_position;
                consum = 0;
                if temp_X_change(3) > 0
                    consum = consum + obj.k_up*obj.load*temp_X_change(3);
                elseif temp_X_change(3) < 0
                    consum = consum - obj.k_down*obj.load*temp_X_change(3);
                end
                consum = consum + obj.k_around*obj.load*sqrt(d_dist^2 - temp_X_change(3)^2);
                obj.power = [obj.power;obj.power(end)-consum(1)];
                obj.position = [obj.position;next_position];
                % 改变当前位置
                now_position = next_position;
                % 检验合理性
                if obj.power(end) < 0
                    warning("无人机电量耗尽！")
                    obj.speed(end,:) = [];
                    obj.time(end,:) = [];
                    obj.power(end,:) = [];
                    obj.load(end,:) = [];
                    obj.position(end,:) = [];
                    return
                end
                if ~(obj.isreachable_point(obj.position(end,:),obstacle_tree) &&...
                        obj.isreachable_point(obj.position(end,:),obstacle_field))
                    warning("遇到障碍物！，故障点位置：")
                    disp(obj.position(end,:))
                    obj.speed(end,:) = [];
                    obj.time(end,:) = [];
                    obj.power(end,:) = [];
                    obj.load(end,:) = [];
                    obj.position(end,:) = [];
                    return
                end
            end
        end

        % 无人机以速度speed从当前点出发前往下一个点，当遇到障碍物时，会尽可能尝试灵活的绕过障碍物前进
        function obj = FlyToNextPoint_flexible_try(obj,point_next,speed,load,obstacle_tree,obstacle_field)
            % 飞行合理性检验
            if isempty(speed)
                speed = obj.speed(end);
            end
            if isempty(load)
                load = obj.load(end);
            end
            if speed < 0
                error("speed必须大于0")
            elseif speed > obj.max_speed
                error("speed必须小于无人机的最大速度")
            end
            if load < 0
                error("load必须大于0")
            elseif load > obj.max_load
                error("load必须小于无人机的最大负载")
            end
            if point_next(3) > obj.max_altitude
                error("无人机要到达的地方海拔太高！")
            end

            % 进行飞行
            d_dist = speed*obj.dt; % 每一个dt时段内飞行的路程
            now_position = obj.position(end,:); % 当前无人机位置
            while norm(now_position - point_next) > d_dist
                % 开始迭代飞行过程
                direction = (point_next - now_position)/norm(now_position - point_next);
                next_position = findProperPoint_Tofly_try(now_position,direction,d_dist,...
                    obstacle_field,obstacle_tree);

                % 更新参数
                obj.speed = [obj.speed;speed];
                obj.time = [obj.time;obj.time(end)+obj.dt];
                obj.load = [obj.load;load];
                temp_X_change = next_position - now_position;
                consum = 0;
                if temp_X_change(3) > 0
                    consum = consum + obj.k_up*obj.load*temp_X_change(3);
                elseif temp_X_change(3) < 0
                    consum = consum - obj.k_down*obj.load*temp_X_change(3);
                end
                consum = consum + obj.k_around*obj.load*sqrt(d_dist^2 - temp_X_change(3)^2);
                obj.power = [obj.power;obj.power(end)-consum(1)];
                obj.position = [obj.position;next_position];
                % 改变当前位置
                now_position = next_position;
            end
        end

    end
end

