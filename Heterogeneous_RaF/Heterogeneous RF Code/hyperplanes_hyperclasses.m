function H_hyper= hyperplanes_hyperclasses(Data,group,unique_label,Label,minleaf,option)

classifier = option.classifier;
H_hyper = zeros(size(Data,2)+1,size(group,1));

for k = 1:size(group,1)
    
    group_temp = group(k,:);
    group1_indx = find(group_temp);
    group1 = unique_label(group1_indx);
    group2 = setdiff(unique_label,group1);
    
    m1 = length(group1);
    m2 = length(group2);
    index1 = [];
    for i=1:m1
        index=find(Label==group1(i));
        index1=[index1;index];
    end
    index2=[];
    for i=1:m2
        index=find(Label==group2(i));
        index2=[index2;index];
    end
    
    
    if strcmp(classifier,'lda')
        Label_temp = Label;
        Label_temp(index1) = 0; % temporary assignment
        Label_temp(index2) = 1;
        H_hyper(:,k) = LDA(Data,Label_temp);
    else
        grouping.group1 = group1;
        grouping.group2 = group2;
        H_hyper(:,k) = hyperplane_psvm(Data,Label,minleaf,grouping);
    end
    
end


end
%EOF