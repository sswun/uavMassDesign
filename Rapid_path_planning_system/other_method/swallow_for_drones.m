%% 结合燕群的粒子群优化算法设计——旅行商问题
function [Shortest_Route,Shortest_Length]=swallow_for_drones(points,numofpar,epo)
citys=points;
fun_fitness=@(x)HPSSO_TSP(x,citys); % 适应度函数
position_floor=zeros(1,size(citys,1)); % 粒子位置下限
position_ceil=ones(1,size(citys,1)); % 粒子位置上限
% 算法参数设置
alphaHL=2;
betaHL=2;
alphaLL=2;
betaLL=2;
numofneiber=5;
%% 迭代计算
T=50; % 每轮迭代次数
% 初始化燕群
pars=[];
for i=1:numofpar
    temp_par=HPSSO_particle(fun_fitness,position_floor,position_ceil,...
        alphaHL,betaHL,alphaLL,betaLL,numofneiber);
    pars=[pars;temp_par];
end
best_par=pars(1);
% 迭代计算
for i1=1:epo
    for i2=1:T
        for i3=1:numofpar
            pars(i3)=pars(i3).refresh_position(pars);
        end
    end
    tempbest_par=pars(1);
    for i2=2:numofpar
        if(pars(i2).fitness<tempbest_par.fitness)
            tempbest_par=pars(i2);
        end
    end
    if(best_par.fitness>tempbest_par.fitness)
        best_par=tempbest_par;
    end
end
[Shortest_Route,Shortest_Length]=HPSSO_TSP_getinfor(best_par.best_position,citys);
end