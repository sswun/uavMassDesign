% 创建一个简单的环境
classdef SimpleEnvironment < handle
    properties
        currentState
        isDone
    end
    
    methods
        function obj = SimpleEnvironment()
            obj.currentState = randn(1);  % 初始状态为随机数
            obj.isDone = false;
        end
        
        function [nextState, reward, isDone] = step(obj, action)
            % 在此简单示例中，状态更新为当前状态加上动作
            obj.currentState = obj.currentState + action;
            
            % 计算奖励（示例中奖励为当前状态的相反数）
            reward = -obj.currentState;
            
            % 判断是否达到终止状态
            obj.isDone = abs(obj.currentState) > 5;
            isDone = obj.isDone;
            
            % 返回下一个状态
            nextState = obj.currentState;
        end
    end
end

