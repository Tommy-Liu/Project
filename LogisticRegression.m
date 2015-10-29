function w = LogisticRegression(data, label, num_labels, lambda)
m = size(data, 1);
n = size(data, 2);

w = ones(num_labels, n + 1);
% Add ones to the X data matrix
X = [ones(m, 1) data];
for i = 1:num_labels
    fprintf('Label %d train.\n',i);
        initial_w = zeros(n + 1, 1);
        %options = optimset('lArgeScale', 'off','MaxIter', 500,'TolFun', 1e-8);
        options = optimset('GradObj', 'on', 'MaxIter', 50);
        [w(i,:)] = ...
            fmincg (@(t)(ObjectiveFunction(t, X, (label == i), lambda)), ...
            initial_w, options)';
%     lr = 0.01;
%         loss = inf;
%         prevloss = 0;
%     acc = 0;
%     while(acc < 99)
%         fprintf('------>');
%         [loss, grad] = ObjectiveFunction(w(i,:)',X,(label == i),lambda);
%                 prevloss = loss;
%         w(i,:) = w(i,:) - 2 * lr * grad';
%         res = sigmoid(X * w(i,:)') > 0.5;
%         acc = sum(res == (label == i),1) / size(X,1) * 100;
%         fprintf('Loss: %f ,Accuracy: %f\n',loss,acc);
%     end
    fprintf('done.\n');
end
end

function dst = sigmoid(h)
dst = 1.0 ./ ( 1.0 + exp(- h ));
end

function [loss, grad] = ObjectiveFunction(w, data, label, lambda)
m = size(label,1);
h = sigmoid(data * w);
loss = ( sum( - label .* log( h ) - ( 1 - label ) .* log( 1 - h ), 1 ) ) / m + lambda * sum( w( 2 : end ) .^ 2, 1 ) / ( 2 * m );
grad = ( sum( repmat( ( h - label ), 1, size( data, 2) ) .* data, 1) )' / m + lambda * [0;w(2:end)] / m;
grad = grad(:);
end