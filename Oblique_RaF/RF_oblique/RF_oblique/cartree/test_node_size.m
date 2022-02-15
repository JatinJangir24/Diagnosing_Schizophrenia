clc;
L1=length(model3);
Minleaf=10000;
for i=1:L1
    model_temp=model(i);
    index_temp=model_temp.nodeDataIndex;
    length_temp=length(index_temp);
    for j=1:length_temp
        if length(index_temp{j})~=0
        L=length(index_temp{j});
        if L<Minleaf
            Minleaf=L;
        end
        end
    end
end
Minleaf