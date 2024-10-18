function draw_trees(trees, field_tree)
% 绘制物体
if ~isempty(trees)
    for i=1:length(trees)
        if trees(i).state <= 2
            drawellipsoid(trees(i).position_toppart-[0,0,trees(i).height/4],trees(i).radius_toppart/2,trees(i).radius_toppart/2,trees(i).radius_toppart/2)
            drawcylinder(trees(i).position_bottompart-[0,0,trees(i).height/2], ...
                trees(i).position_bottompart(3)-trees(i).position(3),trees(i).radius_bottompart/2)
        elseif trees(i).state == 3
            drawcuboid(trees(i).position,trees(i).volume(1),trees(i).volume(2),trees(i).volume(3))
        elseif trees(i).state == 4
            drawellipsoid(trees(i).position,trees(i).volume(1)/2,trees(i).volume(2)/2,trees(i).volume(3)/2)
        end
    end
end
if ~isempty(field_tree)
    temp_points = [[field_tree.xmin,field_tree.ymin,0];[field_tree.xmax,field_tree.ymin,0];[field_tree.xmax,field_tree.ymin,0];[field_tree.xmax,field_tree.ymax,0]];
    plotSurfaceFromPoints([field_tree.positions;temp_points])
end