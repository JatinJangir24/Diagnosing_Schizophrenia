function b = RR(TrainX,TrainY,minleaf)

[~,numFeatures] = size(TrainX);
b = zeros(numFeatures+1,1);

l = -5:5;%range of lambda
indx_lambda = randi(length(l));
lambda_temp = l(indx_lambda);
lambda = 10.^lambda_temp;%vary for each node

K = kernel_matrix_comp(TrainX,'lin_kernel');
c = pinv(K+lambda*eye(size(K,1)))*TrainX'*TrainY;

Data_temp = TrainX*c;
[~, bias] = axis_parallel_cut(TrainY,Data_temp,minleaf);

b(1:end-1) = c;
b(end) = bias;

end

