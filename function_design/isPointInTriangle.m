function isInside = isPointInTriangle(point, triangle)
    % point 是一个 1x2 的向量，表示要判断的点 [x, y]
    % triangle 是一个 3x2 的矩阵，每行表示三角形的一个顶点 [x, y]

    % 提取三角形的三个顶点
    p1 = triangle(1, :);
    p2 = triangle(2, :);
    p3 = triangle(3, :);

    % 计算三个子三角形的面积
    A = triangleArea(p1, p2, p3);
    A1 = triangleArea(point, p2, p3);
    A2 = triangleArea(p1, point, p3);
    A3 = triangleArea(p1, p2, point);

    % 如果点在三角形内或边上，A1 + A2 + A3 应该等于 A
    if abs(A - (A1 + A2 + A3)) < 1e-10
        isInside = true;
    else
        isInside = false;
    end
end

function A = triangleArea(p1, p2, p3)
    % 计算由三点构成的三角形的面积
    A = 0.5 * abs(p1(1)*(p2(2)-p3(2)) + p2(1)*(p3(2)-p1(2)) + p3(1)*(p1(2)-p2(2)));
end