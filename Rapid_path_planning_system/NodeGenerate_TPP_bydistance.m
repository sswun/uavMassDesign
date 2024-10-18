function points_generate = NodeGenerate_TPP_bydistance(start_point,target_point,field_tree,trees)
%% 在field_tree和trees环境中，从某点出发到另外一点，生成一些节点,节点生成数量与距离有关系
% 设置一个允许的距离范围，让路径规划只要在起始点和目标点距离范围之内就可以
range = 4;

% 找到可行的起始点和目标点
start_point = findPossiblepointinRange(start_point,field_tree,trees,range);
target_point = findPossiblepointinRange(target_point,field_tree,trees,range);

% 连接起始点和目标点，设置k个标记点
k = ceil(norm(target_point - start_point));
points_mark = [];
for i=1:length(start_point)
    points_markX = linspace(start_point(i),target_point(i),k);
    points_mark = [points_mark;points_markX];
end
points_mark = points_mark';
num_max = 20;
range_generate = 8;
points_generate = [];
for i=1:size(points_mark,1)
    point_generate = generatePossiblepointinRange(points_mark(i,:),field_tree,...
        trees,range_generate,num_max);
    points_generate = [points_generate;point_generate];
end

% 对生成的节点排序
points_generate = sort_ifclosertoPoint(points_generate,start_point);
points_generate = [start_point;points_generate;target_point];
end

