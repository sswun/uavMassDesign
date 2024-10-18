% 创建 Actor 和 Critic 网络（简化为单层神经网络）
classdef SimpleNetwork < handle
    properties
        weights
    end
    
    methods
        function obj = SimpleNetwork()
            obj.weights = randn(1, 2);  % 简单的权重初始化
        end
        
        function actions = predict(obj, states)
            actions = states * obj.weights';
        end
        
        function gradients = computeGradients(obj, states, criticGradients)
            gradients = criticGradients * obj.weights;
        end
        
        function updateWeights(obj, sourceWeights, tau)
            obj.weights = tau * sourceWeights + (1 - tau) * obj.weights;
        end
        
        function weights = getWeights(obj)
            weights = obj.weights;
        end
    end
end