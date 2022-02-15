function gini = ideal_gini(Labels,current_class)

index_neg = find(Labels~=current_class); 

label_neg = Labels(index_neg);
unique_label_neg = unique(label_neg);

count_neg = zeros(1,length(unique_label_neg));  

for i=1:length(unique_label_neg)
    count_neg(i) = length(find(label_neg==unique_label_neg(i)));
    count_neg(i) = (count_neg(i)/length(index_neg))^2;
end

ratio = length(index_neg)/length(Labels);
gini = ratio*(1-sum(count_neg));


end
%EOF
