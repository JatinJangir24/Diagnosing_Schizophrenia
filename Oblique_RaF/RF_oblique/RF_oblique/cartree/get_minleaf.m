function [minleaf,X,Y]=get_minleaf(model)
minleaf=1000;
L=length(model);
for i=1:L
    idx=model(i).nodeDataIndex;
    L1=length(idx);
    for j=1:L1
        
        L_temp=length(idx{j});
        if L_temp<minleaf 
           minleaf=L_temp; 
           X=i;
           Y=j;
        end
    end
end










end