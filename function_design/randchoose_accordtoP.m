%% 根据输入概率随机选择某个数
function num = randchoose_accordtoP(Prob)
if sum(Prob) > 1
    Prob = Prob/sum(Prob);
elseif sum(Prob) <= 1e-5
    warning("输入概率为负数或概率之和为0,此时将随机返回一个数")
    num = randperm(length(Prob),1);
    return
end
% 累积概率分布
cumulativeProb = cumsum(Prob);
% 生成一个在 [0, 1] 范围内的随机数
randomValue = rand();
% 根据随机数在累积概率分布中的位置选择对应的数组下标
num = find(cumulativeProb >= randomValue, 1, 'first');
return
end

