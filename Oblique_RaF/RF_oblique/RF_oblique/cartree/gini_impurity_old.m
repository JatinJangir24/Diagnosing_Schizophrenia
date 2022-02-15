function [cut_value, impurity]=gini_impurity(Labels, Data,minleaf)
cut_value=0;
impurity=0;
Labels_temp=unique(Labels);
num_labels=length(Labels_temp);
diff_labels_l = zeros(1,num_labels);
diff_labels_r = zeros(1,num_labels);
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
  
 

for nl=1:num_labels
    diff_labels_r(nl)=diff_labels(nl);
    
end

[sort_value,sort_index]=sort(Data,'ascend');
sort_labels=Labels(sort_index);
%calculate gini after a node

for mj=1:minleaf
    cl=sort_labels(mj);
    index=find(Labels_temp==cl);
    diff_labels_l(index)=diff_labels_l(index)+1;
    diff_labels_r(index)=diff_labels_r(index)-1;
    
end



for j=minleaf+1:M-minleaf
    temp=sort_labels(j);
    cl=find(Labels_temp==temp);
    diff_labels_l(cl)= diff_labels_l(cl)+1;
    diff_labels_r(cl)=diff_labels_r(cl)-1;
    gr=0;
    gl=0;
    
  for nl=1:num_labels
      gl=gl+diff_labels_l(nl)*diff_labels_l(nl);
      gr=gr+diff_labels_r(nl)*diff_labels_r(nl);
               
  end
    gl=1-gl/(j*j);
    gr=1-gr/((M-j)*(M-j));
    post_gini=j*gl/M+(M-j)*gr/M;

    if post_gini<pre_gini
        pre_gini=post_gini;
        cut_value=0.5*(sort_value(j)+sort_value(j+1));
        impurity=post_gini;
    end
end