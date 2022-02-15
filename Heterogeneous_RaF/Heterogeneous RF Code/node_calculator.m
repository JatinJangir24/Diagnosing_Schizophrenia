clc

load('result_linearclassifier_abalone.mat','model_tree')
numRF = size(model_tree,1);
num_nodes = zeros(500,numRF); %500 is the ensemble size

for i = 1:numRF
    
    Random_Forest = model_tree{i,1};
    [~,m] = size(Random_Forest);
        
    for j = 1:m
        num_leaves = numel(find(Random_Forest(j).nodeCutVar == 0));
        num_nodes(j,i) = num_leaves-1; 
    end
    
    
end
temp_avg = mean(num_nodes,1);
Avg_NumNodes = mean(temp_avg,2)



