function [Random_Forest,Trainningtime ]= ObliqueRF_train(Data,Labels,option)
                 

mtry = option.nvartosample;
nTrees = option.ntrees;
            
Trainningtime=0;
n = length(Labels);

for i = 1 : nTrees
    
    TDindx = round(numel(Labels)*rand(n,1)+.5);
      
     
   tic            
    Random_ForestT = cartree_train(Data(TDindx,:),Labels(TDindx),TDindx,mtry); 
    Trainingtime_temp=toc;
    Trainningtime=Trainningtime+Trainingtime_temp;

    method = 'c';
    Random_ForestT.method = method;

    Random_ForestT.oobe = 1;
  
    Random_Forest(i) = Random_ForestT; 
   
end

end


 