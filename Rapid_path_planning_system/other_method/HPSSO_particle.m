%% 结合燕群的改进粒子群算法类设计
classdef HPSSO_particle
    properties
        fun_fitness; % 适应度函数
        position; % 当前粒子位置
        position_floor; % 粒子位置下限
        position_ceil; % 粒子位置上限
        best_position; % 个体历史最优位置
        fitness; % 当前粒子适应值
        fitness_best; % 个体历史最优适应度
        numofdim; % 位置维度个数
        alphaHL; % HL影响下：个体最优因子
        betaHL; % HL影响下：群体最优因子
        alphaLL; % LL影响下：个体最优因子
        betaLL; % LL影响下：邻居最优因子
        numofneiber; % 邻居数量设定
        vhl;
        vll;
    end
    methods
        % 初始化
        function obj=HPSSO_particle(fun_fitness,position_floor,position_ceil,...
                alphaHL,betaHL,alphaLL,betaLL,numofneiber)
            obj.fun_fitness=fun_fitness;
            obj.position_floor=position_floor;
            obj.position_ceil=position_ceil;
            obj.alphaHL=alphaHL;
            obj.betaHL=betaHL;
            obj.alphaLL=alphaLL;
            obj.betaLL=betaLL;
            obj.numofneiber=numofneiber;
            obj.numofdim=size(obj.position_floor,2);
            obj.position=obj.position_floor+rand(1,obj.numofdim).*...
                (obj.position_ceil-obj.position_floor);
            obj.best_position=obj.position;
            obj.fitness=obj.fun_fitness(obj.position);
            obj.fitness_best=obj.fitness;
            obj.vhl=0;
            obj.vll=0;
        end
        function obj=reinit(obj,fun_fitness,position_floor,position_ceil,...
                alphaHL,betaHL,alphaLL,betaLL,numofneiber)
            obj.fun_fitness=fun_fitness;
            obj.position_floor=position_floor;
            obj.position_ceil=position_ceil;
            obj.alphaHL=alphaHL;
            obj.betaHL=betaHL;
            obj.alphaLL=alphaLL;
            obj.betaLL=betaLL;
            obj.numofneiber=numofneiber;
            obj.numofdim=size(obj.position_floor,2);
            obj.position=obj.position_floor+rand(1,obj.numofdim).*...
                (obj.position_ceil-obj.position_floor);
            obj.best_position=obj.position;
            obj.fitness=obj.fun_fitness(obj.position);
            obj.fitness_best=obj.fitness;
            obj.vhl=0;
            obj.vll=0;
        end
        % 判断位置信息是否相同
        function judg=isinsameposition(obj,particle)
            judg=0;
            if(obj.position==particle.position)
                judg=1;
                return
            end
            return
        end
        % 返回距离
        function dist=distance(obj,particle)
            dist=norm(obj.position-particle.position);
            return
        end
        % 位置更新
        function obj=refresh_position(obj,HPSSO_particles)
            % 找到全局最优位置
            numofhpsso=length(HPSSO_particles);
            fitnessgbest=HPSSO_particles(1).fitness;
            gbest=HPSSO_particles(1);
            for i=2:numofhpsso
                if(HPSSO_particles(i).fitness<fitnessgbest)
                    fitnessgbest=HPSSO_particles(i).fitness;
                    gbest=HPSSO_particles(i);
                end
            end
            % 找到邻居最优位置
            neighs=HPSSO_particles;
            for i=1:obj.numofneiber
                for j=numofhpsso-1:-1:i
                    if(obj.distance(neighs(j))>obj.distance(neighs(j+1)))
                        temp=neighs(j);
                        neighs(j)=neighs(j+1);
                        neighs(j+1)=temp;
                    end
                end
            end
            neighs=neighs(1:obj.numofneiber);
            fitnesslbest=neighs(1).fitness;
            lbest=neighs(1);
            for i=2:length(neighs)
                if(neighs(i).fitness<fitnesslbest)
                    fitnesslbest=neighs(i).fitness;
                    lbest=neighs(i);
                end
            end
            % 更新位置
            obj.vhl=obj.vhl+obj.alphaHL*rand()*(obj.best_position-obj.position)...
                +obj.betaHL*rand()*(gbest.position-obj.position);
            obj.vll=obj.vll+obj.alphaLL*rand()*(obj.best_position-obj.position)...
                +obj.betaLL*rand()*(lbest.position-obj.position);
            v=obj.vhl+obj.vll;
            for i=1:obj.numofdim
                if(obj.position(i)+v(i)>obj.position_ceil(i))
                    obj.position(i)=obj.position(i)+rand()*...
                        (obj.position_ceil(i)-obj.position(i));
                elseif(obj.position(i)+v(i)<obj.position_floor(i))
                    obj.position(i)=obj.position(i)+rand()*...
                        (obj.position_floor(i)-obj.position(i));
                else
                    obj.position(i)=obj.position(i)+v(i);
                end
            end
            obj.fitness=obj.fun_fitness(obj.position);
            if(obj.fitness<obj.fitness_best)
                obj.fitness_best=obj.fitness;
                obj.best_position=obj.position;
            end
        end
    end
end