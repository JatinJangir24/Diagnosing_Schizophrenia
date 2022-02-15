function [Sb,Sw]=get_matrix_lda(Input,Target)
[n, m] = size(Input);
ClassLabel = unique(Target);
k = length(ClassLabel);

nGroup     = NaN(k,1);     % Group counts

Sw  = zeros(m,m);   % Pooled covariance
Sb  = zeros(m,m);
mean_data=mean(Input);
for i = 1:k,
   
    Group      = (Target == ClassLabel(i));
    nGroup(i)  = sum(double(Group));
    Sw = Sw + ((nGroup(i) - 1) / (n - k) ).* cov(Input(Group,:));
    Sb=Sb+nGroup(i)* (mean(Input(Group,:))-mean_data)'*(mean(Input(Group,:))-mean_data);
end

end