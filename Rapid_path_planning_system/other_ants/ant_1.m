%% 蚁群算法中改进蚂蚁类设计1.0
classdef ant_1
    %ANT 存储当前位置，走过的路径，节点数量，路径距离；可以选择下一节点
    properties
        position; % 当前蚂蚁位置
        way; % 蚂蚁走过的路径
        numofpositions; % 节点数量
        length; % 路径长度
        length_t; % 当前走过距离
    end
    methods
        % 初始化
        function obj = ant_1(pos,numofpositions)
            obj.position=pos;
            obj.way=zeros(1,numofpositions);
            obj.way(1)=pos;
            obj.numofpositions=numofpositions;
            obj.length=0;
            obj.length_t=0;
        end
        function obj = reinit(obj,pos,numofpositions)
            obj.position=pos;
            obj.way=zeros(1,numofpositions);
            obj.way(1)=pos;
            obj.numofpositions=numofpositions;
            obj.length=0;
            obj.length_t=0;
        end
        % 选择下一节点走
        function obj=choose_next_position(obj,w_adj,tao_pheromone,alpha,beta)
            % 传入参数为：w_adj邻接矩阵，tao_pheromone信息素浓度矩阵
            % alpha路径长短决定因素，beta信息素浓度决定因素
            [~,error_check]=find(obj.way==0,1);
            if(error_check==1)
                obj.position=randsrc(1,1,1:obj.numofpositions);
                obj.way(1)=obj.position;
                return
            elseif(size(error_check,1)==0)
                return
            elseif(error_check==obj.numofpositions)
                for i=1:obj.numofpositions
                    if(~ismember(i,obj.way))
                        temp_position=i;
                        break
                    end
                end
                obj.length=obj.length+w_adj(obj.position,temp_position);
                obj.length_t=w_adj(obj.position,temp_position);
                obj.position=temp_position;
                obj.way(error_check)=obj.position;
                return
            end
            % 计算选择下一节点的概率矩阵
            probility_nextnode=zeros(1,obj.numofpositions);
            for i=1:obj.numofpositions
                if(~ismember(i,obj.way))
                    probility_nextnode(i)=abs(tao_pheromone(obj.position,i)^alpha*...
                        (1/w_adj(obj.position,i))^beta);
                end
            end
            probility_nextnode=probility_nextnode/(sum(probility_nextnode));
            for i=1:size(probility_nextnode,2)
                if(probility_nextnode(i)==1)
                    break
                elseif(probility_nextnode(i)~=0)
                    probility_nextnode(i)=tan(0.9272*(probility_nextnode(i)-0.5))+0.5;
                end
            end
            temp_position=randchoose_fromproblity(probility_nextnode);
            temp_check=0;
            while 1
                if(ismember(temp_position,obj.way))
                    temp_position=randchoose_fromproblity(probility_nextnode);
                    temp_check=temp_check+1;
                else
                    break
                end
                if(temp_check==1000)
                    for i=1:obj.numofpositions
                        if(~ismember(i,obj.way))
                            temp_position=i;
                            break
                        end
                    end
                    obj.length=obj.length+w_adj(obj.position,temp_position);
                    obj.length_t=w_adj(obj.position,temp_position);
                    obj.position=temp_position;
                    obj.way(error_check)=obj.position;
                    return
                end
            end
            obj.length=obj.length+w_adj(obj.position,temp_position);
            obj.length_t=w_adj(obj.position,temp_position);
            obj.position=temp_position;
            obj.way(error_check)=obj.position;
        end
    end
end

