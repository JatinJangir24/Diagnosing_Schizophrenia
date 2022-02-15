function gini = select_hyperplane_hyper(b_hyper,Data,Labels,minleaf)

numofBound = size(b_hyper,2);
gini = ones(1,numofBound);

for z=1:numofBound
    
    b = b_hyper(:,z);
    
    Y = Data*b(1:end-1);
    index_pos = find(Y>b(end));
    index_neg = find(Y<=b(end));
    
    flag1=(length(index_pos)>=minleaf && length(index_neg)>=minleaf);
    
    if flag1==0
        gini(1,z) = 1;
    else
        
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
end

end
%EOF
