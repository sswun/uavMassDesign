function drawcuboid(center, length, width, height)  
% 绘制长方体，输入中心坐标及长宽高
    % center: 长方体的中心位置 [x, y, z]  
    % length: 长方体的长度  
    % width: 长方体的宽度  
    % height: 长方体的高度  
  
     % 分解中心位置  
    cx = center(1);  
    cy = center(2);  
    cz = center(3);  
      
    % 计算长方体的8个顶点  
    x = [cx-length/2, cx+length/2, cx+length/2, cx-length/2, cx-length/2, cx+length/2, cx+length/2, cx-length/2];  
    y = [cy-width/2, cy-width/2, cy+width/2, cy+width/2, cy-width/2, cy-width/2, cy+width/2, cy+width/2];  
    z = [cz-height/2, cz-height/2, cz-height/2, cz-height/2, cz+height/2, cz+height/2, cz+height/2, cz+height/2];  
      
    % 创建6个面的网格  
    % 前面和后面  
    X1 = [x(1:4); x(5:8)];  
    Y1 = [y(1:4); y(5:8)];  
    Z1 = [z(1:4); z(5:8)];  
    % 左面和右面  
    X2 = [x([1,2,6,5]); x([3,4,8,7])];  
    Y2 = [y([1,2,6,5]); y([3,4,8,7])];  
    Z2 = [z([1,2,6,5]); z([3,4,8,7])];  
    % 上面和下面  
    X3 = [x([1,2,3,4]); x([5,6,7,8])];  
    Y3 = [y([1,2,3,4]); y([5,6,7,8])];  
    Z3 = [z([1,2,3,4]); z([5,6,7,8])];  
      
    % 绘制6个面  
    hold on
    surf(X1, Y1, Z1, 'FaceColor', 'r', 'EdgeColor', 'k'); % 前面和后面  
    surf(X2, Y2, Z2, 'FaceColor', 'g', 'EdgeColor', 'k'); % 左面和右面  
    surf(X3, Y3, Z3, 'FaceColor', 'b', 'EdgeColor', 'k'); % 上面和下面  
end