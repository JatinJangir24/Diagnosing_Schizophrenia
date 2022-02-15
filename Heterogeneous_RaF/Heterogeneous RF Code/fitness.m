function dunn_ind = fitness(pop,group,unique_label,class_dist)

ind = 1:length(unique_label);
dunn_ind = zeros(size(pop,1),1);

distance = group.distance;

for i = 1:size(pop,1)
    
    ind_group1 = find(pop(i,:));
    ind_group2 = setdiff(ind,ind_group1);
    
    if isempty(ind_group1) || isempty(ind_group2)
        continue
    end    
       
      
    dist_temp_num = distance(ind_group1,ind_group2);
  
      
    num_d = min(mean(dist_temp_num,2)); %intercluster distance
   
    aa = min(min(dist_temp_num));
    [nearestClass1_ind_temp,nearestClass2_ind_temp] = find(dist_temp_num==aa);
    %debugging
    if length(nearestClass1_ind_temp)>1 ||  length(nearestClass2_ind_temp)>1
        nearestClass1_ind_temp = nearestClass1_ind_temp(1);
        nearestClass2_ind_temp = nearestClass2_ind_temp(1);   
    end
    
    nearestClass1_ind = ind_group1(nearestClass1_ind_temp);
    nearestClass2_ind = ind_group2(nearestClass2_ind_temp);
    total_noSamples_group1 = sum(class_dist(ind_group1));
    total_noSamples_group2 = sum(class_dist(ind_group2));
    ratioOfnear1 = (class_dist(nearestClass1_ind))/total_noSamples_group1;
    ratioOfnear2 = class_dist(nearestClass2_ind)/total_noSamples_group2;
    dunn_ind(i) = num_d/(ratioOfnear1+ratioOfnear2);   
                   
end

indx = find(isinf(dunn_ind));
if ~isempty(indx)
    dunn_ind(indx) = 0;
end


end