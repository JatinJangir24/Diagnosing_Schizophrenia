function Label_temp = label_generation(group,Label,unique_label) 

group1_indx = find(group);
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
Label_temp = Label;
Label_temp(index1) = 0; 
Label_temp(index2) = 1;

end