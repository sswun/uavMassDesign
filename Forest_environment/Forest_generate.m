%% 生成森林，模拟森林火灾发生环境
clear,clc
% 场地范围限制
xmin=0;
ymin=0;
xmax=100;
ymax=100;
z_range=30;

% 生成树的信息：x,y,z,体积量(0~1),状态(未燃烧0、燃烧1、燃烧且为着火点2)
n_tree = 20;
n_burn = 3;
n_firepoint = 2;
information_tree = [
    xmin,ymin,0,0.9,0;
    xmax,ymax,0,0.9,0;
    ];
n_tree = n_tree - size(information_tree,1);
x_toadd = xmin+(xmax-xmin)*rand(n_tree,1);
y_toadd = ymin+(ymax-ymin)*rand(n_tree,1);
z_toadd = z_range*rand(n_tree,1);
volume_toadd = 0.5+0.5*rand(n_tree,1);
state = zeros(n_tree,1);
information_tree=[information_tree;[x_toadd,y_toadd,z_toadd,volume_toadd,state]];
selectedNumbers_burn = randperm(size(information_tree,1), n_burn);
selectedNumbers_firepoint = randperm(size(information_tree,1), n_firepoint);
information_tree(selectedNumbers_burn,5)=1;
information_tree(selectedNumbers_firepoint,5)=2;

% 生成树的节点以及场地节点
trees = [];
for i=1:size(information_tree,1)
    temp_tree = tree(information_tree(i,4),information_tree(i,5),information_tree(i,1:3));
    trees=[trees;temp_tree];
end
field_tree = field(information_tree(:,1:3));
save Forest_environment\Forest_data.mat field_tree trees information_tree n_tree ...
    selectedNumbers_burn selectedNumbers_firepoint xmin xmax ymin ymax n_burn n_firepoint