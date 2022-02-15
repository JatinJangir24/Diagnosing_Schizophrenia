function [bestCutVar, b] =hyperplane_lda(Data,Label,minleaf)
mean_data=mean(Data,1);
[numdata,numfeature]=size(Data);
if numdata>numfeature
Data1=Data-repmat(mean_data,numdata,1);
[Sb,Sw]=get_matrix_lda(Data1,Label);
[V,~] = eig(Sb,Sw);
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