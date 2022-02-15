function gini=get_gini(data,label,cutvalue,minleaf)
index1=find(data>=cutvalue);
index2=find(data<cutvalue);
label1=label(index1);
label2=label(index2);
ulabel1=unique(label1);
ulabel2=unique(label2);
diff_label_1=zeros(length(ulabel1),1);
diff_label_2=zeros(length(ulabel2),1);
for i=1:length(label1)
    idx=find(ulabel1==label1(i));
    diff_label_1(idx)=diff_label_1(idx)+1;
end
for i=1:length(label2)
    idx=find(ulabel2==label2(i));
    diff_label_2(idx)=diff_label_2(idx)+1;
    
end
g1=0;
for i=1:length(ulabel1)
    g1=g1+diff_label_1(i)*diff_label_1(i);
end
g2=0;
for i=1:length(ulabel2)
    g2=g2+diff_label_2(i)*diff_label_2(i);
end
g1=1-g1/(length(label1)*length(label1));
g2=1-g2/(length(label2)*length(label2));
gini=(length(label1)/length(label))*g1+(length(label2)/length(label))*g2;
if length(index1)<minleaf
    gini=1;
end
if length(index2)<minleaf
    gini=1;
end
end