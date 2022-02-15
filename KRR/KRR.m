function [train_accuracy,test_accuracy,beta, Yt_temp]=KRR(trainX,trainY,testX,testY,option)
U_trainY=unique(trainY);
nclass=numel(U_trainY);
trainY_temp=zeros(numel(trainY),nclass);
% 0-1 coding for the target
for i=1:nclass
    idx= trainY==U_trainY(i);
    
    trainY_temp(idx,i)=1;
end
[Nsample,Nfea]=size(trainX);

%[H, H_test, ~] = kernel_rbf(trainX,testX,option.gamma);
H=kernelfun(trainX,option,trainX);
H_test=kernelfun(testX,option,trainX);
%[H, H_test, ~] = kernel_rbf(trainX,testX,option.gamma);

II = eye(size(H,1));

if ~isfield(option,'C')||isempty(option.C)
    option.C=0.1;
end
C=option.C;
%if N<Nsample
    beta=(eye(size(H,2))/C+H' * H) \ H'*trainY_temp;
%else
 %   beta=H'*((eye(size(H,1))/C+H* H') \ trainY_temp);
%end

trainY_temp=H*beta;
Y_temp=zeros(Nsample,1);
% decode the target
for i=1:Nsample
    [maxvalue,idx]=max(trainY_temp(i,:));
    Y_temp(i)=U_trainY(idx);
end

testY_temp=H_test*beta;
Yt_temp=zeros(numel(testY),1);

for i=1:numel(testY)
    [maxvalue,idx]=max(testY_temp(i,:));
    Yt_temp(i)=U_trainY(idx);
end

train_accuracy=length(find(Y_temp==trainY))/Nsample;

test_accuracy=length(find(Yt_temp==testY))/numel(testY);

end % Function End
