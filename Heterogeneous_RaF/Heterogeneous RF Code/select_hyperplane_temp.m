function [bestCutVar,W_new,min_impurity]=select_hyperplane_temp(W,Data,Labels,minleaf,gini_hyperclasses)

very_small = 0.00001;
Labels_temp = unique(Labels);
num_labels = length(Labels_temp);
diff_labels = zeros(1,num_labels);
M = length(Labels);

numofBound = size(W,2);
gini = ones(1,numofBound);

for i=1:M
    temp = Labels(i);
    index = find(Labels_temp==temp);
    diff_labels(index) = diff_labels(index)+1;
end

pre_gini = 0;
for i=1:num_labels
    pre_gini = pre_gini+diff_labels(i)* diff_labels(i);
end
pre_gini = 1-pre_gini/(M*M);
pre_gini = double(pre_gini);

for z=1:numofBound %loop over all decision boundaries
    
    b = W(:,z);
    if norm(b)==0
        continue
    end
    Y = Data*b(1:end-1);
    index_pos = find(Y>b(end));
    index_neg = find(Y<=b(end));
    flag1=(length(index_pos)>=minleaf && length(index_neg)>=minleaf);
    if flag1==0
        continue
    end
    
    label_pos = Labels(index_pos);
    label_neg = Labels(index_neg);
    unique_label_pos = unique(label_pos);
    unique_label_neg = unique(label_neg);
    count_pos = zeros(1,length(unique_label_pos));
    count_neg = zeros(1,length(unique_label_neg));
    for i=1:length(unique_label_pos)
        count_pos(i) = length(find(label_pos==unique_label_pos(i)));
        count_pos(i) = (count_pos(i)/length(index_pos))^2;
    end
    for i=1:length(unique_label_neg)
        count_neg(i) = length(find(label_neg==unique_label_neg(i)));
        count_neg(i) = (count_neg(i)/length(index_neg))^2;
    end
    ratio1 = length(index_pos)/length(Labels);
    ratio2 = 1-ratio1;
    gini(1,z) = ratio1*(1-sum(count_pos))+ratio2*(1-sum(count_neg));
end

gini = [gini gini_hyperclasses];
[~,min_index] = min(gini);
min_impurity = gini(min_index);
W_new = W(:,min_index);

% if abs(min_impurity-pre_gini)>very_small
if (pre_gini-min_impurity)>very_small
    bestCutVar = 1;
else
    bestCutVar = -1;
    %W_new = zeros(size(W,1),1);
end

end
%EOF
