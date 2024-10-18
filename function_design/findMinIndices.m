%% 找到数组array中最小的numMin个数的下标
function minIndices = findMinIndices(array, numMin)
    % 对数组进行排序，并获取排序后的索引
    [~, sortedIndices] = sort(array);

    % 获取最小的几个数的下标
    minIndices = sortedIndices(1:numMin);
end
