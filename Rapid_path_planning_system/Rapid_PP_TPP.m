function [ants_best,allow,tao_tCopy,tao_eCopy,ant_eCopy,ant_tCopy] = Rapid_PP_TPP(positions,num_e,num_t,num_totest,num_NearestNeighbors)
%% 改进蚁群算法——适用于目标路径规划TPP问题
% positions TPP问题位置，注意此处位置不能随便排列，positions第一个位置是起点，
% 最后一个位置是终点，中间位置按照随起点距离由小到大排列。
% num_e 探索者数量
% num_t 运输者数量
% num_totest 测试轮次
% num_NearestNeighbors 蚁群在选择时，选择从当前点出发向前方最近的num_NearestNeighbors个节点

%% 蚁群信息初始化
vs = 0.1; % 探索者探索阈值
% 信息素及路径长度系数
alpha_e = 2;
alpha_t = 2;
beta_e = 2;
beta_t = 2;
start = 1;% 蚁群起始点位置
% 从positions生成蚁群算法所需的可到达点allow矩阵和allow对应的dist距离矩阵
[allow,dist] = findNearestNeighbors_TPPfit(positions,num_NearestNeighbors);
% 初始化信息素矩阵
initialtao = 5;
tao_e = initialtao*ones(size(allow));
tao_t = initialtao*ones(size(allow));
% 初始化探索者
ant_e = [];
for i=1:num_e
    temp_ant = ant_areasearch(1,start,alpha_e,beta_e);
    ant_e = [ant_e;temp_ant];
end
% 初始化运输者
ant_t = [];
for i=1:num_t
    temp_ant = ant_areasearch(2,start,alpha_e,beta_e);
    temp_ant = temp_ant.t_para_set(alpha_t,beta_t);
    ant_t = [ant_t;temp_ant];
end

%% 迭代计算过程
num_epoch = 20; % 每次迭代轮次
dq = 0.01;
rho = 0.99;
n_e = floor(num_NearestNeighbors/2);
ants_best = [];
for i=1:num_totest
    fprintf("第%d次测试(TSP问题)\n",i)
    % 复制初始化的蚁群信息
    ant_eCopy = ant_e;
    ant_tCopy = ant_t;
    tao_eCopy = tao_e;
    tao_tCopy = tao_t;
    % 探索者更新
    for j=1:num_epoch
        ant_eCopy = ant_e;
        for temp_cho = 1:size(allow,1)
            % 蚁群根据当前信息走完全程
            for temp_i = 1:length(ant_eCopy)
                ant_eCopy(temp_i) = ant_eCopy(temp_i).go_e(allow,tao_eCopy,dist,vs);
            end
            % 更新信息素
            for temp_i = 1:length(ant_eCopy)
                temp_point1=ant_eCopy(temp_i).positions(end - 1);
                temp_point2=ant_eCopy(temp_i).positions(end);
                temp_indice = findFirstElementValue(allow(temp_point1,:),temp_point2);
                tao_eCopy(temp_point1,temp_indice) = ...
                    tao_eCopy(temp_point1,temp_indice)+dq;
            end
            tao_eCopy = tao_eCopy * rho;
        end
    end
    % 运输者更新
    for j=1:num_epoch
        ant_tCopy = ant_t;
        for temp_cho = 1:size(allow,1)
            % 蚁群根据当前信息走完全程
            for temp_i = 1:length(ant_tCopy)
                ant_tCopy(temp_i) = ant_tCopy(temp_i).go_t(allow,tao_eCopy,tao_tCopy,dist,n_e);
            end
            % 更新信息素
            for temp_i = 1:length(ant_tCopy)
                temp_point1=ant_tCopy(temp_i).positions(end - 1);
                temp_point2=ant_tCopy(temp_i).positions(end);
                temp_indice = findFirstElementValue(allow(temp_point1,:),temp_point2);
                tao_tCopy(temp_point1,temp_indice) = ...
                    tao_tCopy(temp_point1,temp_indice)+dq;
            end
            tao_tCopy = tao_tCopy * rho;
        end
    end
    ant_tBest = ant_tCopy(1); % 用来找到路径寻找最优的运输者蚂蚁
    for temp_i = 2:length(ant_tCopy)
        if ant_tCopy(temp_i).distance < ant_tBest.distance
            ant_tBest = ant_tCopy(temp_i);
        end
    end
    ants_best = [ants_best;ant_tBest];
end

end

