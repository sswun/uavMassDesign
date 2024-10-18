%% 输入环境field，tree，判断某点point是否可以在环境中，可以返回true，不能返回false
function isallowed = Is_AllowedinEnv(point,field_tree,trees)
for i=1:length(field_tree)
    if field_tree(i).isunderfield_point(point)
        isallowed = false;
        return
    end
end
for i=1:length(trees)
    if trees(i).isintree_point(point)
        isallowed = false;
        return
    end
end
isallowed = true;
return
end

