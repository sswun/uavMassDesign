function unitVectors = generateUnitVectors(vector, theta, numPoints)
    % 输入：单位向量 (x, y, z) 和夹角 theta（单位为弧度）
    % 输出：与 (x, y, z) 夹角为 theta 的一圈单位向量

    % 确保输入向量是单位向量
    v = vector;
    v = v / norm(v);
    
    % 计算旋转矩阵，将 v 旋转到 z 轴
    zAxis = [0, 0, 1];
    rotationAxis = cross(v, zAxis);
    if norm(rotationAxis) < 1e-10  % v 已经在 z 轴上
        rotationAxis = [1, 0, 0]; % 选择任意轴
    else
        rotationAxis = rotationAxis / norm(rotationAxis);
    end
    angleToZ = acos(dot(v, zAxis));
    R_toZ = rotationMatrix(rotationAxis, angleToZ);
    
    % 计算旋转矩阵，将 z 轴旋转回 v
    R_fromZ = rotationMatrix(rotationAxis, -angleToZ);
    
    % 生成在 xy 平面上与 z 轴夹角为 theta 的一圈点
    %numPoints = 100;
    angles = linspace(0, 2*pi, numPoints);
    circlePoints = zeros(numPoints, 3);
    for i = 1:numPoints
        circlePoints(i, :) = [sin(theta) * cos(angles(i)), sin(theta) * sin(angles(i)), cos(theta)];
    end
    
    % 将点从 z 轴旋转回原始方向
    unitVectors = (R_fromZ * circlePoints')';
end

function R = rotationMatrix(axis, angle)
    % 构造 Rodrigues 旋转矩阵
    K = [0, -axis(3), axis(2); axis(3), 0, -axis(1); -axis(2), axis(1), 0];
    R = eye(3) + sin(angle) * K + (1 - cos(angle)) * (K * K);
end