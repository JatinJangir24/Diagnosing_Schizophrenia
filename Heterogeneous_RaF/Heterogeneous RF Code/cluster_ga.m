function [group_ga_unique,fitnessVals_ga_dunn,fitnessVals_ga_gini] = cluster_ga(group,unique_label,class_dist,Label)

try
    numOfClass = length(unique_label);
    len = numOfClass;  % The length of the genomes
    num_rand_class = round(0.5*len);
    popSize = numOfClass*2;  % The size of the population (must be an even number)
    maxGens = 5;              % The maximum number of generations allowed in a run
    probCrossover = 1;           % The probability of crossing over.
    probMutation = 0.003;        % The mutation probability (per bit)
    sigmaScalingFlag = 1;        % Sigma Scaling is described on pg 168 of M. Mitchell's
    % GA book. It often improves GA performance.
    sigmaScalingCoeff = 1;       % Higher values => less fitness pressure
    
    SUSFlag = 1;                 % 1 => Use Stochastic Universal Sampling (pg 168 of
    %      M. Mitchell's GA book)
    % 0 => Do not use Stochastic Universal Sampling
    %      Stochastic Universal Sampling almost always
    %      improves performance
    
    crossoverType = 2;           % 0 => no crossover
    % 1 => 1pt crossover
    % 2 => uniform crossover
    
    useMaskRepositoriesFlag = 1; % 1 => draw uniform crossover and mutation masks from
    %      a pregenerated repository of randomly generated bits.
    %      Significantly improves the speed of the code with
    %      no apparent changes in the behavior of
    %      the SGA
    % 0 => generate uniform crossover and mutation
    %      masks on the fly. Slower.
    
    
    
    % crossover masks to use if crossoverType==0.
    mutationOnlycrossmasks=false(popSize,len);
    
    % pre-generate two “repositories” of random binary digits from which the
    % the masks used in mutation and uniform crossover will be picked.
    % maskReposFactor determines the size of these repositories.
    
    maskReposFactor=5;
    uniformCrossmaskRepos=rand(popSize/2,(len+1)*maskReposFactor)<0.5;
    mutmaskRepos=rand(popSize,(len+1)*maskReposFactor)<probMutation;
         
    % generate population
    [pop,first_pop,rand_class] = gen_pop(group,popSize,unique_label);
    
    pop_gen = [];
    fitnessVals_dunn_gen = [];
    fitnessVals_gini_gen = [];
    
    
    for gen=1:maxGens
        
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
        
        rank_gini = tiedrank(fitnessVals_gini);
        rank_dunn = tiedrank(fitnessVals_dunn);
        total_rank = rank_gini+rank_dunn;
        [rank_sorted,indx_sorted] = sort(total_rank,'descend');
        
        fitnessVals = total_rank;        
             
        pop_sorted = pop(indx_sorted,:);
        fitnessVals_dunn_sorted = fitnessVals_dunn(indx_sorted);
        fitnessVals_gini_sorted =  fitnessVals_gini(indx_sorted);
        
        pop_gen = [pop_gen;pop_sorted(1:numOfClass,:)];
        fitnessVals_dunn_gen = [fitnessVals_dunn_gen;fitnessVals_dunn_sorted(1:numOfClass)];
        fitnessVals_gini_gen = [fitnessVals_gini_gen;fitnessVals_gini_sorted(1:numOfClass)];
        
        
        
        % Conditionally perform sigma scaling
        if sigmaScalingFlag
            sigma=std(fitnessVals);
            if sigma~=0
                fitnessVals=1+(fitnessVals-mean(fitnessVals))/...
                    (sigmaScalingCoeff*sigma);
                fitnessVals(fitnessVals<=0)=0;
            else
                fitnessVals=ones(popSize,1);
            end
        end
        
        
        % Normalize the fitness values and then create an array with the
        % cumulative normalized fitness values (the last value in this array
        % will be 1)
        cumNormFitnessVals=cumsum(fitnessVals/sum(fitnessVals));
        cumNormFitnessVals = cumNormFitnessVals';
        
        % Use fitness proportional selection with Stochastic Universal or Roulette
        % Wheel Sampling to determine the indices of the parents
        % of all crossover operations
        if SUSFlag
            markers=rand(1,1)+[1:popSize]/popSize;
            markers(markers>1)=markers(markers>1)-1;
        else
            markers=rand(1,popSize);
        end
        [temp, parentIndices]=histc(markers,[0 cumNormFitnessVals]);
        parentIndices=parentIndices(randperm(popSize));
        
        % deterimine the first parents of each mating pair
        firstParents=pop(parentIndices(1:popSize/2),:);
        % determine the second parents of each mating pair
        secondParents=pop(parentIndices(popSize/2+1:end),:);
        
        % create crossover masks
        if crossoverType==0
            masks=mutationOnlycrossmasks;
        elseif crossoverType==1
            masks=false(popSize/2, len);
            temp=ceil(rand(popSize/2,1)*(len-1));
            for i=1:popSize/2
                masks(i,1:temp(i))=true;
            end
        else
            if useMaskRepositoriesFlag
                temp=floor(rand*len*(maskReposFactor-1));
                masks=uniformCrossmaskRepos(:,temp+1:temp+len);
            else
                masks=rand(popSize/2, len)<.5;
            end
        end
        
        % overriding the masks so that crossover is done only on the
        % randomized classes
        masks_temp1 = masks(:,rand_class);
        masks_temp2 = repmat(first_pop,size(masks,1),1);
        masks_temp2(:,rand_class) = masks_temp1;
        masks = logical(masks_temp2);
        
        % determine which parent pairs to leave uncrossed
        reprodIndices=rand(popSize/2,1)<1-probCrossover;
        masks(reprodIndices,:)=false;
        
        % implement crossover
        firstKids=firstParents;
        firstKids(masks)=secondParents(masks);
        secondKids=secondParents;
        secondKids(masks)=firstParents(masks);
        pop=[firstKids; secondKids];
        
        % implement mutation
        if useMaskRepositoriesFlag
            temp=floor(rand*len*(maskReposFactor-1));
            masks=mutmaskRepos(:,temp+1:temp+len);
            % overriding the masks so that crossover is done only on the
            % randomized classes
            masks_temp1 = masks(:,rand_class);
            masks_temp2 = repmat(first_pop,size(masks,1),1);
            masks_temp2(:,rand_class) = masks_temp1;
            masks = logical(masks_temp2);
        else
            masks=rand(popSize, len)<probMutation;
        end
        pop=xor(pop,masks);
    end
    %find the unique solutions
    [group_ga_unique,indx] = unique(pop_gen,'rows');
    fitnessVals_ga_dunn = fitnessVals_dunn_gen(indx);
    fitnessVals_ga_gini = fitnessVals_gini_gen(indx);
    
    %if number of hyperclasses is greater than number of 1vsall partitions,
    %select top ranked hyperclasses equal to the number of partitions
    numOfpart = size(group_ga_unique,1);
    if numOfpart>numOfClass
        rank_gini = tiedrank(fitnessVals_ga_gini);
        rank_dunn = tiedrank(fitnessVals_ga_dunn);
        total_rank = rank_gini+rank_dunn;
        [rank_sorted,indx_sorted] = sort(total_rank,'descend');
        group_ga_sorted =  group_ga_unique(indx_sorted,:);
        fitnessVals_dunn_sorted =  fitnessVals_ga_dunn(indx_sorted);
        fitnessVals_gini_sorted = fitnessVals_ga_gini(indx_sorted);
        group_ga_unique =  group_ga_sorted(1:numOfClass,:);
        fitnessVals_ga_dunn = fitnessVals_dunn_sorted(1:numOfClass);
        fitnessVals_ga_gini = fitnessVals_gini_sorted(1:numOfClass);
    end
    
catch
    group_ga_unique = [];
    fitnessVals_ga_dunn = [];
    fitnessVals_ga_gini = [];
        
end


end
%EOF