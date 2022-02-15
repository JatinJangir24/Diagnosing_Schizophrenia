function [gini,flag] = ideal_gini_hyperclass(group1,group2,Label)

m1 = length(group1);
m2 = length(group2);
index_pos = [];
for i=1:m1
    index=find(Label==group1(i));
    index_pos=[index_pos;index];
end
index_neg = [];
for i=1:m2
    index=find(Label==group2(i));
    index_neg = [index_neg;index];
end

label_pos = Label(index_pos);
label_neg = Label(index_neg);
unique_label_pos = group1;
unique_label_neg = group2;
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
ratio1 = length(index_pos)/length(Label);
ratio2 = 1-ratio1;
gini = ratio1*(1-sum(count_pos))+ratio2*(1-sum(count_neg));

%flag checks if any groups have classes assigned to only 1 hyperclass
flag = (m1==0) || (m2==0);
flag = ~flag;
end