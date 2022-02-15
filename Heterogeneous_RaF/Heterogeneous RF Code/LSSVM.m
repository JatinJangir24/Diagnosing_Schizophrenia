function b = LSSVM(X,Y)

[~,numFeatures] = size(X);
b = zeros(numFeatures+1,1);

gam = -2:7; %range of gamma in LS-SVM
indx_gam = randi(length(gam));
gamma_temp = gam(indx_gam);
G = 10.^gamma_temp;%vary for each node

type = 'classification';
[alpha,bias] = trainlssvm({X,Y,type,G,[],'lin_kernel','original'});

w = alpha' * X; %weight coefficients

b(1:end-1) = w;
b(end) = bias;

end

