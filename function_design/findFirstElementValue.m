function index = findFirstElementValue(array, targetValue)

try
    % 使用 find 函数找到数组中等于 targetValue 的元素的下标
    indices = find(array == targetValue);

    % 获取第一个出现的元素的下标
    if ~isempty(indices)
        index = indices(1);
    else
        index = [];  % 如果没有找到匹配的元素，则返回空数组
    end
catch
    for i=1:length(array)
        if array(i) == targetValue
            index = i;
            return
        end
    end
    if i== length(array)
        index =[];
        return
    else
        error("程序运行错误！")
    end
end
end
