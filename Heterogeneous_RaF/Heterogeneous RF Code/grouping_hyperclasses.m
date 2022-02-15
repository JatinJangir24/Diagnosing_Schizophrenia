function [group_hyperclass,fitnessVals_dunn,fitnessVals_gini,distance] = grouping_hyperclasses(Data,Label)

unique_label = unique(Label);
class_dist = hist(Label,unique_label);

group_bhatta = group([Label,Data]);
distance = group_bhatta.distance;

[group_hyperclass,fitnessVals_dunn,fitnessVals_gini] = cluster_hyperclass(group_bhatta,unique_label,class_dist,Label);

end
%EOF