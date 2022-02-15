function[bestCutVar,W_new]=hyperplane_psvm(Data,Label,P,minleaf,delta)
% P=1, use Tikhonov regularization when SSS
% P=2, perform axis parallel partition when SSS
% bestCutVar indicates whether it is necessary to conduct a hyperplan, only
% valid for P=2.
unique_label=unique(Label);
flag_temp=1;
m=length(unique_label);
BAD_flag=0;
XX=unique(Label);
if length(XX)==1
   bestCutVar=-1;
   BAD_flag=1;
   W_new=zeros(size(Data,2)+1,1)';
end
if BAD_flag==0
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
flag2=rank(H)==size(H,1);
flag=flag1*flag2;
if flag==1
[eig_vector1,eig_value]=my_eig(H,G);
eig_vector1=eig_vector1(:,1);
W1=eig_vector1;
[eig_vector2,eig_value]=my_eig(G,H);
W2=eig_vector2(:,1);

W=[W1,W2];

else
   
    if P==1
       
       
        G1=G+delta*eye(size(G,1));
        [eig_vector1,eig_value]=my_eig(H,G1);
        eig_vector1=eig_vector1(:,1);
        W1=eig_vector1;
        H1=H+delta*eye(size(G,1));
        [eig_vector2,eig_value]=my_eig(G,H1);
        W2=eig_vector2(:,1);
        W=[W1,W2];
    end
    if P==2
      [bestCutVar1 ,BestCutValue] =axis_parallel_cut(Label,Data,minleaf);
      W1=zeros(size(G,1),1);
      W1(end)=BestCutValue;
      
      if bestCutVar1~=-1
        W1(bestCutVar1)=1;  
      end
      W=[W1,W1];
     flag_temp=0;
    end
end
 [bestCutVar,W_new]=select_hyperplane(W,Data,Label,minleaf);
 if flag_temp==0
      bestCutVar=bestCutVar1;
 end
end
end