function [points,points_field] = fieldShape_generate(trees, field_tree)
points = [];
if ~isempty(trees)
    for i=1:length(trees)
        if trees(i).state <= 2
            for x=trees(i).position(1)-trees(i).height:0.5:trees(i).position(1)+trees(i).height
                for y=trees(i).position(2)-trees(i).height:0.5:trees(i).position(2)+trees(i).height
                    for z=trees(i).position(3):0.3:2*trees(i).position(3)+trees(i).height
                        if trees(i).isintree_point([x,y,z])
                            points=[points;[x,y,z]];
                        end
                    end
                end
            end
        else
            for x=trees(i).position(1)-0.5*trees(i).volume(1):0.5:trees(i).position(1)+0.5*trees(i).volume(1)
                for y=trees(i).position(2)-0.5*trees(i).volume(2):0.5:trees(i).position(2)+0.5*trees(i).volume(2)
                    for z=trees(i).position(3)-0.5*trees(i).volume(3):0.3:trees(i).position(3)+0.5*trees(i).volume(3)
                        if trees(i).isintree_point([x,y,z])
                            points=[points;[x,y,z]];
                        end
                    end
                end
            end
        end
    end
end
points_field = [];
if ~isempty(field_tree)
    for x=field_tree.xmin:0.5:field_tree.xmax
        for y=field_tree.ymin:0.5:field_tree.ymax
            for z=-1:0.1:field_tree.zmax
                if ~field_tree.isunderfield_point([x,y,z])
                    points_field=[points_field;[x,y,z]];
                    break
                end
            end
        end
    end
end