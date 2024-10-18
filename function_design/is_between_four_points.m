%% 判断两直线交点是否在4个点之间
function judgment=is_between_four_points(point_line1_1,point_line1_2,...
    point_line2_1,point_line2_2)
intsection=intersection_of_two_lines(point_line1_1,point_line1_2,...
    point_line2_1,point_line2_2);
if(isnan(intsection))
    judgment=false;
    return
end
if(is_between_two_points(point_line1_1,point_line1_2,intsection))
    if(is_between_two_points(point_line2_1,point_line2_2,intsection))
        judgment=true;
        return
    end
end
judgment=false;
return
end