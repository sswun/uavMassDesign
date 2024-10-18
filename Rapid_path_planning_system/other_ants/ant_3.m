%% 蚁群算法中改进蚂蚁类设计3.0，适用区域覆盖搜索,softfunchange,群类多样化
classdef ant_3
    properties
        position; % 当前蚂蚁位置
        way; % 蚂蚁走过的路径
        numofpositions; % 节点数量
        length; % 路径长度
        length_t; % 当前走过距离
        numchoose; % 选择最近的numchoose个位置作为备选移动位置
    end
    methods
        % 初始化
        function obj = ant_3(pos,numofpositions,numchoose)
            obj.position=pos;
            obj.way=zeros(1,numofpositions);
            obj.way(1)=pos;
            obj.numofpositions=numofpositions;
            obj.length=0;
            obj.length_t=0;
            obj.numchoose=numchoose;
        end
        function obj = reinit(obj,pos,numofpositions)
            obj.position=pos;
            obj.way=zeros(1,numofpositions);
            obj.way(1)=pos;
            obj.numofpositions=numofpositions;
            obj.length=0;
            obj.length_t=0;
        end
        % 探索者：选择下一节点走
        function obj=choose_next_position(obj,w_adj,tao_pheromone,alpha_e,beta_e,vs)
            % 传入参数为：w_adj邻接矩阵，tao_pheromone探索者信息素浓度矩阵
            % alpha_e路径长短决定因素，beta_e信息素浓度决定因素
            % vs为随机选择路径的阈值
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
            numtocho=[];
            for i=1:obj.numofpositions
                if(~ismember(i,obj.way))
                    numtocho=[numtocho,i];
                    probility_nextnode(i)=abs(tao_pheromone(obj.position,i)^alpha_e*...
                        (1/w_adj(obj.position,i))^beta_e);
                end
            end
            % 选择最近的n个位置作为待选节点
            if(size(numtocho,2)>obj.numchoose)
                for i=1:obj.numchoose
                    for j=size(numtocho,2)-1:-1:1
                        if(w_adj(obj.position,numtocho(j))>...
                                w_adj(obj.position,numtocho(j+1)))
                            tempnumcho=numtocho(j);
                            numtocho(j)=numtocho(j+1);
                            numtocho(j+1)=tempnumcho;
                        end
                    end
                end
                probility_nextnode(numtocho(obj.numchoose+1:end))=0;
            end
            % 当随机数小于vs时，随机选择路径
            if(rand()<vs)
                for i=1:obj.numofpositions
                    if(probility_nextnode(i)~=0)
                        probility_nextnode(i)=0.1;
                    end
                end
            end
            probility_nextnode=probility_nextnode/(sum(probility_nextnode));
            for i=1:size(probility_nextnode,2)
                if(probility_nextnode(i)==1)
                    break
                elseif(probility_nextnode(i)~=0)
                    probility_nextnode(i)=4*(probility_nextnode(i)-0.5).^3+0.5;
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
        % 运输者：选择下一节点走
        function obj=choose_next_position_trans(obj,w_adj,tao_pheromonee,...
                tao_pheromonet,alpha_t,beta_t,alpha_et)
            % 传入参数为：w_adj邻接矩阵，tao_pheromonee探索者信息素浓度矩阵
            % tao_pheromonet运输者信息素浓度矩阵
            % alpha_t运输者路径长短决定因素，beta_t运输者信息素浓度决定因素
            % alpha_et为探索者对运输者的引导
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
            numtocho=[];
            for i=1:obj.numofpositions
                if(~ismember(i,obj.way))
                    numtocho=[numtocho,i];
                    probility_nextnode(i)=abs(tao_pheromonee(obj.position,i)^alpha_et...
                        *tao_pheromonet(obj.position,i)^alpha_t*...
                        (1/w_adj(obj.position,i))^beta_t);
                end
            end
            % 选择最近的n个位置作为待选节点
            if(size(numtocho,2)>obj.numchoose)
                for i=1:obj.numchoose
                    for j=size(numtocho,2)-1:-1:1
                        if(w_adj(obj.position,numtocho(j))>...
                                w_adj(obj.position,numtocho(j+1)))
                            tempnumcho=numtocho(j);
                            numtocho(j)=numtocho(j+1);
                            numtocho(j+1)=tempnumcho;
                        end
                    end
                end
                probility_nextnode(numtocho(obj.numchoose+1:end))=0;
            end
            probility_nextnode=probility_nextnode/(sum(probility_nextnode));
            for i=1:size(probility_nextnode,2)
                if(probility_nextnode(i)==1)
                    break
                elseif(probility_nextnode(i)~=0)
                    probility_nextnode(i)=4*(probility_nextnode(i)-0.5).^3+0.5;
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
