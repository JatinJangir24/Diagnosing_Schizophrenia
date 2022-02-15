function b = hyperplane_psvm(Data,Label,minleaf,grouping)

delta = 0.01;

group1 =  grouping.group1;
group2 =  grouping.group2;

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

Data_A=Data(index1,:);
Data_B=Data(index2,:);
A=[Data_A,-1*ones(size(Data_A,1),1)];
B=[Data_B,-1*ones(size(Data_B,1),1)];
G=A'*A/size(A,1);
H=B'*B/size(B,1);

flag1=rank(G)==size(G,1);
flag2=rank(H)==size(H,1);
flag=flag1*flag2;

if flag==1
    
    [eig_vector1,~]=my_eig(H,G);
    eig_vector1=eig_vector1(:,1);
    W1=eig_vector1;
    [eig_vector2,~]=my_eig(G,H);
    W2=eig_vector2(:,1);
    W=[W1,W2];
else
    G1 = G+delta*eye(size(G,1));
    [eig_vector1,eig_value] = my_eig(H,G1);
    eig_vector1 = eig_vector1(:,1);
    W1 = eig_vector1;
    H1 = H+delta*eye(size(G,1));
    [eig_vector2,eig_value] = my_eig(G,H1);
    W2 = eig_vector2(:,1);
    W = [W1,W2];
    
end

 [bestCutVar,b] = select_hyperplane_psvm(W,Data,Label,minleaf);
end
%EOF