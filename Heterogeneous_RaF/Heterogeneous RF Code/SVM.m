function b = SVM(Input,Target)

[numSample,numFeatures] = size(Input);
b = zeros(numFeatures+1,1);

r = -2:7;%range of C-parameter for SVM
indx_C = randi(length(r));
C_temp = r(indx_C);
C = 2.^C_temp;%vary for each node

cmd = ['-s -t -h -c -q', 0,0,0,num2str(C)];
cl = svmtrain(Target,Input,cmd);
beta = cl.SVs'*cl.sv_coef; %weight coefficients
bias = -cl.rho; %bias term

b(1:end-1) = beta;
b(end) = bias;

end
% EOF


