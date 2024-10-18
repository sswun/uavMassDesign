function drawellipsoid(center, a, b, c)  
% 绘制椭球体，输入中心位置及长轴半径、中轴半径、短轴半径
    % center: 椭球体的中心位置 [x, y, z]  
    % a: 椭球体的长轴半径  
    % b: 椭球体的中轴半径  
    % c: 椭球体的短轴半径  
  
    % 定义参数方程中的参数范围和步长  
    theta = linspace(0, 2*pi, 40); % 方位角  
    phi = linspace(0, pi, 40); % 极角  
  
    % 生成网格  
    [Theta, Phi] = meshgrid(theta, phi);  
  
    % 定义椭球体的参数方程  
    X = a * cos(Theta) .* sin(Phi) + center(1);  
    Y = b * sin(Theta) .* sin(Phi) + center(2);  
    Z = c * cos(Phi) + center(3);  
  
    % 绘制椭球体   
    surf(X, Y, Z);  
    axis equal;  
    shading interp;  
end