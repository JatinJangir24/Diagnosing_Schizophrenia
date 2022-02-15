function [pop,first_pop,rand_class] = gen_pop(group,popSize,unique_label)

% Population is created as follows:
% 1. Original solution using Bhatta. distance
% 2. 50% are randomized to create whole population
numOfClass = length(unique_label);
len = 1:numOfClass;
group1 = group.group1;
%group2 = group.group2;
group1_extreme = group.group1_extreme;
group2_extreme = group.group2_extreme;

%find the indices of groups in unique label
[~,group1_indx] = intersect(unique_label,group1);
%[~,group2_indx] = intersect(unique_label,group2);
[~,group1_extreme_indx] = intersect(unique_label,group1_extreme);
[~,group2_extreme_indx] = intersect(unique_label,group2_extreme);


first_pop = zeros(1,numOfClass);
first_pop(group1_indx) = 1;
% for the rest of population, we randomly assign to two extreme classes
num_rand_class = round(0.5*numOfClass); %number of classes to be randomized

%pop_temp = first_pop;

dis_diff = 0;
distance = group.distance;
%the classes are selected based on their distances from two extreme classes
for i = 1:numOfClass
    distance_group1 = distance(group1_extreme_indx,len(i));
    distance_group2 = distance(group2_extreme_indx,len(i));
    diff = abs(distance_group1-distance_group2);
    dis_diff = [dis_diff;diff];
end
dis_diff = dis_diff(2:end);
[dis_diff,ind] = sort(dis_diff,'ascend');
rand_class = ind(1:num_rand_class); %select classes that will be randomly assigned to two extreme classes

%generate random assignments to the above found classes and create
%population
pop_final = first_pop;
for j = 1:popSize-1
    random_gen = rand(1,num_rand_class)<.5;
    rem_pop = first_pop;
    rem_pop(rand_class) = random_gen;
    pop_final = [pop_final;rem_pop];
end

pop = pop_final;

end
%EOF