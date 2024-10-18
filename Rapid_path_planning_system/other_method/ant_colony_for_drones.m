%% 经典蚁群算法解决无人机线路规划
function [Routes,lengths]=ant_colony_for_drones(points, numofants,numtotest)
%% 初始化参数
m=numofants;% 蚂蚁个数
Alpha=2;% 信息素重要程度参数
Beta=2;% 启发式因子重要程度参数
Rho=0.1;% 信息素蒸发系数
G=50;% 最大迭代次数
Q=100;% 信息素增加强度系数
C=points;% 城市坐标
n=size(C,1);% n表示问题的规模(城市个数)
D=zeros(n);% D表示两个城市距离间隔矩阵
for i = 1:n
    for j = 1:n
        if i ~= j
            D(i,j) = ((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
        else
            D(i,j) = eps;
        end
        D(j,i) = D(i,j);
    end
end
Eta=1./D;% Eta为启发因子，这里设为距离的倒数
Tau=ones(n);% Tau为信息素矩阵
Tabu=zeros(m,n);% 存储并记录路径的生成
NC=1; %迭代计数器
R_best=zeros(G,n); %各代最佳路线
L_best=inf.*ones(G,1); %各代最佳路线的长度
%% 蚁群算法迭代计算过程
Routes=[];
lengths=[];
for numtest=1:numtotest
    while NC<=G
        % 将m只蚂蚁放到n个城市上
        Randpos=[];
        for i = 1:(ceil(m/n))
            Randpos=[Randpos,randperm(n)];
        end
        Tabu(:,1) = (Randpos(1,1:m))';
        % m只蚂蚁按概率函数选择下一座城市，完成各自的周游
        for j=2:n
            for i=1:m
                visited=Tabu(i,1:(j-1));% 已访问的城市
                J=zeros(1,(n-j+1));% 待访问的城市
                P=J;% 待访问城市的选择概率分布
                Jc=1;
                for k=1:n
                    if isempty(find(visited==k, 1))
                        J(Jc)=k;
                        Jc=Jc+1;
                    end
                end
                % 计算待选城市的概率分布
                for k=1:length(J)
                    P(k)=(Tau(visited(end),J(k))^Alpha)...
                        *(Eta(visited(end),J(k))^Beta);
                end
                P=P/(sum(P));
                % 按概率原则选取下一个城市
                Pcum=cumsum(P);
                Select=find(Pcum >= rand);
                to_visit=J(Select(1));
                Tabu(i,j)=to_visit;
            end
        end
        if NC>=2
            Tabu(1,:)=R_best(NC-1,:);
        end
        % 记录本次迭代最佳路线
        L=zeros(m,1);
        for i=1:m
            R=Tabu(i,:);
            for j=1:(n-1)
                L(i)=L(i)+D(R(j),R(j+1));
            end
            L(i)=L(i)+D(R(1),R(n));
        end
        L_best(NC)=min(L);
        pos=find(L==L_best(NC));
        R_best(NC,:)=Tabu(pos(1),:);
        % 更新信息素
        Delta_Tau=zeros(n,n);
        for i=1:m
            for j=1:(n-1)
                Delta_Tau(Tabu(i,j),Tabu(i,j+1))= ...
                    Delta_Tau(Tabu(i,j),Tabu(i,j+1))+Q/L(i);
            end
            Delta_Tau(Tabu(i,n),Tabu(i,1))= ...
                Delta_Tau(Tabu(i,n),Tabu(i,1))+Q/L(i);
        end
        Tau = (1-Rho).*Tau+Delta_Tau;
        % 禁忌表清零
        Tabu=zeros(m,n);
        NC = NC+1;
    end
    % 输出结果
    Pos = find(L_best==min(L_best));
    Shortest_Route=R_best(Pos(1),:);% 最佳路线
    Shortest_Length=L_best(Pos(1));% 最佳路线长度
    Routes=[Routes;Shortest_Route];
    lengths=[lengths;Shortest_Length];
end
end