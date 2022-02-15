function [group_GAorExha,fitnessVals_dunn,fitnessVals]  = cluster_hyperclass(group,unique_label,class_dist,Label)

numOfClass = length(unique_label);

if numOfClass>=8
    [group_GAorExha,fitnessVals_dunn,fitnessVals]  = cluster_ga(group,unique_label,class_dist,Label);
else
    [group_GAorExha,fitnessVals_dunn,fitnessVals] = exhaustiveSearch(group,unique_label,class_dist,Label);
end



end
%EOF