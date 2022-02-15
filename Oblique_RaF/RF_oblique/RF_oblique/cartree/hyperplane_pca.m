function [bestCutVar, b] =hyperplane_pca(Data,Label,minleaf)
mean_data=mean(Data,1);
[numdata,numfeature]=size(Data);
if numdata>numfeature
Data1=Data-repmat(mean_data,numdata,1);
covariancematrix=cov(Data1);
[V,~] = eig(covariancematrix);
Data_temp=Data*V;

[bestCutVar, bestCutValue] =axis_parallel_cut(Label,Data_temp,minleaf);
b=zeros(numfeature+1,1);
if bestCutVar~=-1
b(1:numfeature)=V(:,bestCutVar);
b(end)=bestCutValue;
end
else
 [bestCutVar, bestCutValue] =axis_parallel_cut(Label,Data,minleaf);
 b=zeros(numfeature+1,1);
 if bestCutVar~=-1
b(bestCutVar)=1;
b(end)=bestCutValue;
end
end
end