%% 两直线交点位置
function point_intersection=intersection_of_two_lines(point_line1_1,point_line1_2,...
    point_line2_1,point_line2_2)
%% 判断是否平行或重合,若是，返回nan
if((point_line1_1(1)==point_line1_2(1))&&(point_line2_1(1)==point_line2_2(1)))
    point_intersection=nan;
    return
end
if((point_line2_2(2)-point_line2_1(2))/(point_line2_2(1)-point_line2_1(1))==...
        (point_line1_2(2)-point_line1_1(2))/(point_line1_2(1)-point_line1_1(1)))
    point_intersection=nan;
    return
end
%% 求交点
a1=point_line1_2(2)-point_line1_1(2);
a2=point_line2_2(2)-point_line2_1(2);
b1=-(point_line1_2(1)-point_line1_1(1));
b2=-(point_line2_2(1)-point_line2_1(1));
c1=(point_line1_2(1)-point_line1_1(1))*point_line1_1(2)-...
    (point_line1_2(2)-point_line1_1(2))*point_line1_1(1);
c2=(point_line2_2(1)-point_line2_1(1))*point_line2_1(2)-...
    (point_line2_2(2)-point_line2_1(2))*point_line2_1(1);
coef_matrix1=[a1,b1;a2,b2];
coef_matrix2=[-c1;-c2];
point_intersection=(coef_matrix1\coef_matrix2)';
end