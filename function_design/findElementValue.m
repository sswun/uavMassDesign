function indices = findElementValue(array, targetValue)
    % 使用 find 函数找到数组中等于 targetValue 的元素的下标
    indices = find(array == targetValue);
end
