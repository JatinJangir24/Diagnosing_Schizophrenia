function bestCutVar = select_hyperplane_onlyhyper(Labels,gini_hyperclass)

very_small = 0.00001;
Labels_temp = unique(Labels);
num_labels = length(Labels_temp);
diff_labels = zeros(1,num_labels);
M = length(Labels);

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

% if abs(min_impurity-pre_gini)>very_small
if (pre_gini-gini_hyperclass)>very_small
    bestCutVar = 1;
else
    bestCutVar = -1;
    %W_new = zeros(size(W,1),1);
end

end
%EOF
