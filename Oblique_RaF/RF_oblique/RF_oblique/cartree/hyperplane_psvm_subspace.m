function [ bestCutVar,W]=hyperplane_psvm_subspace(Data,Label,minleaf)
% [ bestCutVar,W,pre_gini,post_gini]=hyperplane_psvm_subspace(Data,Label)
% solve Sb/Sw.  


% transform into the nullspace of Sw, choose the eigenvector of Sb in
% the null space of Sb corresonding to the largest eigenvalue.

unique_label=unique(Label);
m=length(unique_label);
if m>=3
    [group1,group2]=group([Label,Data]);
    else
    group1=unique_label(1);
    group2=unique_label(2);
end
 m1=length(group1);
 m2=length(group2);
 index1=[];
 for i=1:m1
    index=find(Label==group1(i));
    index1=[index1;index];
 end
index2=[];
for i=1:m2
    index=find(Label==group2(i));
    index2=[index2;index];
end
if size(index1,2)~=1
    index1=index1';
end
if size(index2,2)~=1
    index2=index2';
end
Label_A=Label(index1);
Label_B=Label(index2);
Data_A=Data(index1,:);
Data_B=Data(index2,:);
A=[Data_A,-1*ones(size(Data_A,1),1)];
B=[Data_B,-1*ones(size(Data_B,1),1)];
G=A'*A/size(A,1);
H=B'*B/size(B,1);
flag1=rank(G)==size(G,1);


if flag1==1
[eig_vector1,eig_value]=my_eig(H,G);
eig_vector1=eig_vector1(:,1);
W1=eig_vector1;

[eig_vector2,eig_value]=my_eig(H,G);
W2=eig_vector2(:,end);

W=[W1,W2];



else
   
%     if P==1
%         [eigen_vector1,eigen_value]=my_eig(G,eye(size(G,1)));
%         Projection=eigen_vector1(:,1:rank(G));
%         A=A*Projection;
%         B=B*Projection;
%         G1=A'*A/size(A,1);
%         H1=B'*B/size(B,1);
%         [eig_vector1,eig_value]=my_eig(H1,G1);
%         eig_vector1=eig_vector1(:,1);
%         W1=eig_vector1;
%         [eig_vector2,eig_value]=my_eig(H1,G1);
%         W2=eig_vector2(:,end);
% 
%         W=[W1,W2];
%         bestCutVar=1;
%     end
%     if P==2
        
       [eigen_vector1,eigen_value]=my_eig(G,eye(size(G,1)));
        Projection1=eigen_vector1(:,rank(G)+1:end);
        
        B=B*Projection1*Projection1';
        H1=B'*B/size(B,1);
        [eig_vector1,eig_value]=my_eig(H1,eye(size(H1)));
        W1=eig_vector1(:,1);
        [eigen_vector2,eigen_value]=my_eig(H,eye(size(H,1)));
        Projection1=eigen_vector2(:,rank(H)+1:end);
        
        A=A*Projection1*Projection1';
        G1=A'*A/size(A,1);
        [eig_vector2,eig_value]=my_eig(G1,eye(size(G1)));
        W2=eig_vector2(:,1);
     
        W=[W1,W2];
        
%     end
        
end
% [bestCutVar,W,pre_gini,post_gini]=select_hyperplane(W,Data,Label);
[bestCutVar,W]=select_hyperplane(W,Data,Label,minleaf);
  
end