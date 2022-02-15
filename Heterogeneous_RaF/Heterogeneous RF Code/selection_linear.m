function [bestCutVar,H,l_num]= selection_linear(Data,Label,minleaf)

flag = 0;
numfeature = size(Data,2);
unique_label = unique(Label);
m = length(unique_label);
b = zeros(numfeature+1,m);

for i = 1:m
    Label_group = double(Label==unique_label(i));
    b(:,i) = psvm(Data,Label_group,minleaf);
end

[bestCutVar,H] = select_hyperplane(b,Data,Label,minleaf,flag);
l_num = 'psvm';


if bestCutVar == -1
    for i = 1:m
        Label_group = double(Label==unique_label(i));
        b(:,i) = logreg(Data,Label_group);
    end
    
    [bestCutVar,H] = select_hyperplane(b,Data,Label,minleaf,flag);
    l_num = 'logreg';
    
    if bestCutVar == -1
        for i = 1:m
            Label_group = double(Label==unique_label(i));
            b(:,i) = LSSVM(Data,Label_group);
        end
        [bestCutVar,H] = select_hyperplane(b,Data,Label,minleaf,flag);
        l_num = 'lssvm';
    end   
    
       
end

end
%EOF