function[bestCutVar,W] = hyperplane_lda(Data,Label,minleaf)

[~,numfeature] = size(Data);
unique_label = unique(Label);
m = length(unique_label);

class_dist = hist(Label,unique_label);

if m==1
    bestCutVar = -1;
    W = zeros(size(Data,2)+1,1);
    
    
elseif m==2
    
    DecBou = decisionBoundaries_twoclass(Data,Label,minleaf);
    [bestCutVar,W] = select_hyperplane(DecBou,Data,Label,minleaf,1,0);
    
    if bestCutVar == -1
        [bestCutVar,bestCutValue] = axis_parallel_cut(Label,Data,minleaf);
        W = zeros(numfeature+1,1);
        if bestCutVar~=-1
            W(bestCutVar)=1;
            W(end)=bestCutValue;
        end
    end
    
    
    
elseif m>=5
    
    %get the hyperclasses and their ideal gini values and dunn index
    [group_hyperclass,dunn_hyperclasses,idealGini_hyperclasses,distance] = grouping_hyperclasses(Data,Label);
    
    
    %compute the ideal gini and dunn index of the 1-vs-all partitions
    idealGini_oneVall= zeros(m,1);
    for i = 1:m
        idealGini_oneVall(i) =  ideal_gini(Label,unique_label(i));
    end
    idealGini_oneVall = 1-idealGini_oneVall;
    
    group_temp1.distance = distance;
    pop = genOnevAll(unique_label);
    dunn_oneVall = fitness(pop,group_temp1,unique_label,class_dist);
    
    dunn_all = [dunn_hyperclasses;dunn_oneVall];
    idealGini_all = [idealGini_hyperclasses;idealGini_oneVall];
    partitions_merged = [group_hyperclass;pop];
    [partitions_merged_unique,indx] = unique(partitions_merged,'rows');
    dunn_all_unique = dunn_all(indx);
    idealGini_all_unique = idealGini_all(indx);
    
      
    rank_gini = tiedrank(idealGini_all_unique);
    rank_dunn = tiedrank(dunn_all_unique);
    total_rank = rank_gini+rank_dunn;
    [rank_sorted,indx_sorted] = sort(total_rank,'descend');
    
    partitions_ranked = partitions_merged_unique(indx_sorted,:);
    numOfpartitions = size(partitions_ranked,1);
    
    if numOfpartitions<=20
        numOfpartitions_lda = numOfpartitions;
        numOfpartitions_mpsvm = numOfpartitions;
    else
        numOfpartitions_lda = round(0.5*numOfpartitions);
        numOfpartitions_mpsvm = round(0.5*numOfpartitions_lda);
    end
    partitions_ranked_lda = partitions_ranked(1:numOfpartitions_lda,:);
    partitions_ranked_mpsvm = partitions_ranked(1:numOfpartitions_mpsvm,:);
    option.classifier = 'lda';
    hyper_lda = hyperplanes_hyperclasses(Data,partitions_ranked_lda,unique_label,Label,minleaf,option);
    option.classifier = 'mpsvm';
    hyper_mpsvm = hyperplanes_hyperclasses(Data,partitions_ranked_mpsvm,unique_label,Label,minleaf,option);
    hyper_ldampsvm = [hyper_lda hyper_mpsvm];
    
    
     %evalute the gini values of these hyperplanes in partitions_ranked
     gini_ldampsvm = select_hyperplane_hyper(hyper_ldampsvm,Data,Label,minleaf);
     gini_ldampsvm_temp = 1-gini_ldampsvm; 
     
    %train other classifier based on the partitions
    numOfpartitions_ldampsvm = size(partitions_ranked,1);
    numOfhyper_logreg = round(0.5*numOfpartitions_ldampsvm);
    hyper_logreg =  zeros(numfeature+1,numOfhyper_logreg);
    partitions_logreg = partitions_ranked(1:numOfhyper_logreg,:);
    for lg = 1:numOfhyper_logreg
        Label_group = label_generation(partitions_logreg(numOfhyper_logreg,:),Label,unique_label);
        hyper_logreg(:,lg) = decisionBoundaries(Data,Label_group,minleaf,'logreg');
    end
    
    numOfhyper_rest = round(0.25*numOfpartitions_ldampsvm);
    hyper_rest =  zeros(numfeature+1,3*numOfhyper_rest);
    partitions_rest = partitions_ranked(1:numOfhyper_rest,:);
    rest_temp = 1;
    for rest = 1:numOfhyper_rest
        Label_group = label_generation(partitions_rest(numOfhyper_rest,:),Label,unique_label);
        hyper_rest(:,rest_temp) = decisionBoundaries(Data,Label_group,minleaf,'lssvm');
        hyper_rest(:,rest_temp+1) = decisionBoundaries(Data,Label_group,minleaf,'svm');
        hyper_rest(:,rest_temp+2) = decisionBoundaries(Data,Label_group,minleaf,'rr');
        rest_temp = rest_temp+3;
    end
    
    total_hyperplanes = [hyper_ldampsvm hyper_logreg hyper_rest];
    [bestCutVar,W,~,~] = select_hyperplane(total_hyperplanes,Data,Label,minleaf,gini_ldampsvm,size(hyper_ldampsvm,2));
    
    if bestCutVar == -1
        [bestCutVar,bestCutValue] = axis_parallel_cut(Label,Data,minleaf);
        W = zeros(numfeature+1,1);
        if bestCutVar~=-1
            W(bestCutVar)=1;
            W(end)=bestCutValue;
        end
        
    end
    
    
else       
    group_bhatta_temp = group([Label,Data]);
    m1 = length(group_bhatta_temp.group1);
    m2 = length(group_bhatta_temp.group2);
    index1 = [];
    for i=1:m1
        index=find(Label==group_bhatta_temp.group1(i));
        index1=[index1;index];
    end
    index2=[];
    for i=1:m2
        index=find(Label==group_bhatta_temp.group2(i));
        index2=[index2;index];
    end
    
    Label_temp = Label;
    Label_temp(index1) = 0; % temporary assignment
    Label_temp(index2) = 1;
    H_hyper_lda = LDA(Data,Label_temp);
    H_hyper_psvm = hyperplane_psvm(Data,Label,minleaf,group_bhatta_temp);
    H_hyper_temp = [H_hyper_lda H_hyper_psvm];
    DecBou = zeros(numfeature+1,1);
    
    for i = 1:m %%loop for all 'k' classifiers
        Label_group = double(Label==unique_label(i));
        DecBou_temp = decisionBoundaries_twoclass(Data,Label_group,minleaf);
        DecBou = [DecBou DecBou_temp];
    end
    DecBou = DecBou(:,2:end);
    DecBou = [DecBou H_hyper_temp];
    [bestCutVar,W,gini_final,min_impurity] = select_hyperplane(DecBou,Data,Label,minleaf,1,0);
    
    if bestCutVar == -1
        [bestCutVar,bestCutValue] = axis_parallel_cut(Label,Data,minleaf);
        W = zeros(numfeature+1,1);
        if bestCutVar~=-1
            W(bestCutVar)=1;
            W(end)=bestCutValue;
        end
    end
    
end


end
%EOF