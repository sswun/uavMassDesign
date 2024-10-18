%% 按照与点point距离对数组排序，越小的越靠前
function array= sort_ifclosertoPoint(array,point)
for i=1:size(array,1)-1
    for j=size(array,1)-1:-1:1
        if norm(array(j,:)-point) > norm(array(j+1,:)-point)
            temp = array(j,:);
            array(j,:) = array(j+1,:);
            array(j+1,:) = temp;
        end
    end
end
end

