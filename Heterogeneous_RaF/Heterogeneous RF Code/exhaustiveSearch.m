function [group_exh_unique,fitnessVals_dunn_unique,fitnessVals_gini_unique] = exhaustiveSearch(group,unique_label,class_dist,Label)

numOfClass = length(unique_label);
class = 1:numOfClass;

num_rand_class = numOfClass;

first_pop = zeros(1,numOfClass);
group1 = group.group1;
[~,ind_group1] = ismember(unique_label,group1);
ind_group1 = find(ind_group1);
first_pop(ind_group1) = 1;

dis_diff = 0;
distance = group.distance;

extreme1_class = group.group1_extreme;
extreme2_class = group.group2_extreme;
[~,ind_ex1] = ismember(unique_label,extreme1_class);
ind_ex1 = find(ind_ex1);
[~,ind_ex2] = ismember(unique_label,extreme2_class);
ind_ex2 = find(ind_ex2);

for i = 1:numOfClass
    distance_group1 = distance(ind_ex1,class(i));
    distance_group2 = distance(ind_ex2,class(i));
    diff = abs(distance_group1-distance_group2);
    dis_diff = [dis_diff;diff];
end
dis_diff = dis_diff(2:end);
[dis_diff,ind] = sort(dis_diff,'ascend');
rand_class = ind(1:num_rand_class); 
extreme_ind = [ind_ex1;ind_ex2];
rand_class = setdiff(rand_class,extreme_ind);
num_rand_class = length(rand_class);


k = 2.^num_rand_class; 
pop = repmat(first_pop,k,1);
random_gen =  dec2bin(0:k-1) - '0'; 
pop(:,rand_class) = random_gen;
pop = [first_pop;pop];

fitnessVals_dunn = fitness(pop,group,unique_label,class_dist);
fitnessVals_gini = zeros(size(pop,1),1);
flag = zeros(size(pop,1),1);

for i = 1:size(pop,1)
    ind_group1 = find(pop(i,:));
    group1 = unique_label(ind_group1);
    group2 = setdiff(unique_label,group1);
    [fitnessVals_gini(i,1),flag(i)] = ideal_gini_hyperclass(group1,group2,Label);
end

fitnessVals_gini = 1-fitnessVals_gini; 
[group_exh_unique,indx] = unique(pop,'rows');
fitnessVals_dunn_unique = fitnessVals_dunn(indx);
fitnessVals_gini_unique = fitnessVals_gini(indx);
flag = flag(indx);


ind_new = find(flag);
group_exh_unique = group_exh_unique(ind_new,:);
fitnessVals_dunn_unique = fitnessVals_dunn_unique(ind_new);
fitnessVals_gini_unique = fitnessVals_gini_unique(ind_new);

numOfpart = size(group_exh_unique,1);
if numOfpart>numOfClass
    rank_gini = tiedrank(fitnessVals_gini_unique);
    rank_dunn = tiedrank(fitnessVals_dunn_unique);
    total_rank = rank_gini+rank_dunn;
    [rank_sorted,indx_sorted] = sort(total_rank,'descend');
    group_exh_sorted =  group_exh_unique(indx_sorted,:);
    fitnessVals_dunn_sorted =  fitnessVals_dunn_unique(indx_sorted);
    fitnessVals_gini_sorted = fitnessVals_gini_unique(indx_sorted);
    group_exh_unique =  group_exh_sorted(1:numOfClass,:);
    fitnessVals_dunn_unique = fitnessVals_dunn_sorted(1:numOfClass);
    fitnessVals_gini_unique = fitnessVals_gini_sorted(1:numOfClass);    
end



if size(group_exh_unique,1)==1 && unique(group_exh_unique==first_pop)==1
    group_exh_unique = [];
    fitnessVals_dunn_unique = [];
    fitnessVals_gini_unique = [];
end


end
%EOF