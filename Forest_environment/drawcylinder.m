function drawcylinder(center, h, r)  
    % 确保输入是数值类型  
    x0 = double(center(1));  
    y0 = double(center(2));  
    z0 = double(center(3));  
    h = double(h);  
    r = double(r);  
      
    % 生成圆柱体侧面的网格  
    [theta, z] = meshgrid(linspace(0, 2*pi, 40), linspace(0, h, 20));  
    x = x0 + r * cos(theta);  
    y = y0 + r * sin(theta);  
    z = z0 + z;  
      
    % 绘制圆柱体侧面  
    surf(x, y, z, 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none');  
    % 设置坐标轴比例和视角  
    axis equal;  
    view(3);  
end