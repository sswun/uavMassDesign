function indices = findElements_A1inA2(array1, array2)
    % 使用 ismember 函数找到 array2 中的元素在 array1 中的下标
    indices = find(ismember(array1, array2));
end
