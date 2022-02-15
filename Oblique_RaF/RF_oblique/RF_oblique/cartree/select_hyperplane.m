% function [bestCutVar,W_new,gini1,gini2,W3,W4]=select_hyperplane(W,Data,Labels)

function [bestCutVar,W_new]=select_hyperplane(W,Data,Labels,minleaf)
% [bestCutVar,W_new,pre_gini,post_gini]=select_hyperplane(W,Data,Labels)
very_small=0.00001;
     Labels_temp=unique(Labels);
     num_labels=length(Labels_temp);
     diff_labels = zeros(1,num_labels);
     M=length(Labels);
      for i=1:M
          temp=Labels(i);
          index=find(Labels_temp==temp);
          diff_labels(index)=diff_labels(index)+1;
      end
      
     pre_gini=0;
    for i=1:num_labels
     pre_gini=pre_gini+diff_labels(i)* diff_labels(i);
    end
    pre_gini=1-pre_gini/(M*M);
    pre_gini=double(pre_gini);
if W(:,1)~=W(:,2)
     W3=zeros(size(W(:,1)));
     W4=zeros(size(W(:,1)));
     W3(1:end-1)=W(1:end-1,1)/norm(W(1:end-1,1))+W(1:end-1,2)/norm(W(1:end-1,2));
     W3(end)=W(end,1)/norm(W(1:end-1,1))+W(end,2)/norm(W(1:end-1,2));
     W4(1:end-1)=W(1:end-1,1)/norm(W(1:end-1,1))-W(1:end-1,2)/norm(W(1:end-1,2));
     W4(end)=W(end,1)/norm(W(1:end-1,1))-W(end,2)/norm(W(1:end-1,2));
else
    W3=W(:,1);
    W4=W(:,1);
end
     
     Y1=Data*W3(1:end-1)-W3(end);
     Y2=Data*W4(1:end-1)-W4(end);
     index_pos=find(Y1>0);
     index_neg=find(Y1<=0);
     flag1=(length(index_pos)>=minleaf && length(index_neg)>=minleaf);
     
     label_pos=Labels(index_pos);
     label_neg=Labels(index_neg);
     unique_label_pos=unique(label_pos);
     unique_label_neg=unique(label_neg);
     count_pos=zeros(1,length(unique_label_pos));
     count_neg=zeros(1,length(unique_label_neg));
     for i=1:length(unique_label_pos)
         count_pos(i)=length(find(label_pos==unique_label_pos(i)));
         count_pos(i)=(count_pos(i)/length(index_pos))^2;
     end
     for i=1:length(unique_label_neg)
         count_neg(i)=length(find(label_neg==unique_label_neg(i)));
         count_neg(i)=(count_neg(i)/length(index_neg))^2;
     end
   ratio1=length(index_pos)/length(Labels);
   ratio2=1-ratio1;
   gini1=ratio1*(1-sum(count_pos))+ratio2*(1-sum(count_neg));  
   
     index_pos=find(Y2>0);
     index_neg=find(Y2<=0);
     label_pos=Labels(index_pos);
     label_neg=Labels(index_neg);
     flag2=(length(index_pos)>=minleaf && length(index_neg)>=minleaf);
     unique_label_pos=unique(label_pos);
     unique_label_neg=unique(label_neg);
     count_pos=zeros(1,length(unique_label_pos));
     count_neg=zeros(1,length(unique_label_neg));
     for i=1:length(unique_label_pos)
         count_pos(i)=length(find(label_pos==unique_label_pos(i)));
         count_pos(i)=(count_pos(i)/length(index_pos))^2;
     end
     for i=1:length(unique_label_neg)
         count_neg(i)=length(find(label_neg==unique_label_neg(i)));
         count_neg(i)=(count_neg(i)/length(index_neg))^2;
     end
  ratio1=length(index_pos)/length(Labels);
  ratio2=1-ratio1;
   gini2=ratio1*(1-sum(count_pos))+ratio2*(1-sum(count_neg));  
   
if flag1*flag2~=0 
if gini1>gini2
    W_new=W4;
else
    W_new=W3;
end
 post_gini=min(gini1,gini2);
post_gini=double(post_gini);
 if abs(post_gini-pre_gini)>very_small
     
    bestCutVar=1;
 else
     
     bestCutVar=-1;
 end
 else 
     if flag1==0 && flag2~=0
         W_new=W4;
         if abs(gini2-pre_gini) >very_small
             bestCutVar=1;
         else
             bestCutVar=-1;
         end
     end
     if flag1~=0 && flag2==0
         W_new=W3;
       if abs(gini1-pre_gini) >very_small
             bestCutVar=1;
             
        else
             bestCutVar=-1;
       end
     end
     if flag1==0 && flag2==0
         W_new=W3;
         bestCutVar=-1;
     end
 end
end