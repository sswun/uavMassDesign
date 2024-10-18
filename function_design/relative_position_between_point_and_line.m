%% 判断点和直线的位置关系，若点在直线上方返回1，若点在直线上返回2，若点在直线下方返回0
function judgment=relative_position_between_point_and_line(point,k,point_line)
if(point_line(2)==point(2))
    if(point_line(1)==point(1))
        judgment=2;
        return
    end
end
y=k*point(1)+point_line(2)-k*point_line(1);
if(point(2)>y)
    judgment=1;
    return
elseif(point(2)==y)
    judgment=2;
    return
elseif(point(2)<y)
    judgment=0;
    return
end
judgment=false;
return
end