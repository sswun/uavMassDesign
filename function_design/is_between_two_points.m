%% 判断某点是否在两点之间正方形区域中
function judgment=is_between_two_points(point1,point2,target_point)
if(point1(1)>point2(1))
    temp=point1(1);
    point1(1)=point2(1);
    point2(1)=temp;
end
if(point1(2)>point2(2))
    temp=point1(2);
    point1(2)=point2(2);
    point2(2)=temp;
end
if(target_point(1)>=point1(1)&&target_point(1)<=point2(1)&&...
        target_point(2)>=point1(2)&&target_point(2)<=point2(2))
    judgment=true;
else
    judgment=false;
end
return
end