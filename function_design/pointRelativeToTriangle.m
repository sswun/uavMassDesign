function position = pointRelativeToTriangle(point, triangle)
    % point 是一个 1x3 的向量，表示要判断的点 [x, y, z]
    % triangle 是一个 3x3 的矩阵，每行表示三角形的一个顶点 [x, y, z]

    % 提取三角形的三个顶点
    p1 = triangle(1, :);
    p2 = triangle(2, :);
    p3 = triangle(3, :);

    % 计算法向量
    normal = cross(p2 - p1, p3 - p1);
    
    % 确保法向量单位化（可选）
    normal = normal / norm(normal);

    % 计算平面方程的常数项 D
    D = -dot(normal, p1);

    % 计算点代入平面方程的值
    distance = dot(normal, point) + D;

    % 判断点相对于平面的相对位置
    if abs(distance) < 1e-10
        position = 0;
    elseif distance > 0
        position = 1;
    else
        position = -1;
    end
end