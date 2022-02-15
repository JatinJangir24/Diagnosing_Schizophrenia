function [eigen_vector,eigen_value]=my_eig(A,B);
% solve the generalized eigenvalue problem
% A*eigen_vector=eigen_value*B*eigen_vector
% The eigenvalues are sorted in descend order , the eigenvectors are sorted
% according to their eigenvalues.
[a,b]=eig(A,B);
m=size(A,1);
eigen_value=zeros(m,1);
for i=1:m
eigen_value(i)=b(i,i);
end
[sort_value,sort_index]=sort(eigen_value,'descend');
eigen_value=eigen_value(sort_index);
eigen_vector=a(:,sort_index);
end