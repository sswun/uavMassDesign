function net2 = copy_net(net1,net2)
% 将net1的参数复制到net2上边
% 假设 net1 和 net2 是两个具有相同结构的 dlnetwork

net2.Learnables = dlupdate(@(x) x, net1.Learnables);

end

