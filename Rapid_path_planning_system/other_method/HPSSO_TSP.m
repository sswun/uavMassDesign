function fitness=HPSSO_TSP(position,citys)
[~,index_position]=sort(position);
position_trans=zeros(1,size(position,2));
for i=1:size(position,2)
    position_trans(index_position(i))=i;
end
fitness=0;
for i=1:size(position,2)
    if(i==size(position,2))
        fitness=fitness+norm(citys(position_trans(i))-citys(position_trans(1)));
    else
        fitness=fitness+norm(citys(position_trans(i))-citys(position_trans(i+1)));
    end
end
end