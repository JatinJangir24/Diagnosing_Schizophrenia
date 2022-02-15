function OptPara=Optimize_Het_RaF(validation_Index)
ALLData=validation_Index.ALL_DATA;
[samples,~]=size(ALLData);
dataTrainingX=ALLData(:,1:end-1);
dataTrainingY=ALLData(:,end);
% dataTrainingY(ALLData(:,end)==1)=-1;%% Keep it 1 for Hc and 2 for
% schizoprenia
% dataTrainingY(ALLData(:,end)==2)=1;
p=validation_Index.p; % 10 fold cross validation
cvFolds=validation_Index.cvFolds;

%% decide the ensemble size of the trees ntry and the mtry for each tree mtry
ntree=100;

s = RandStream('mcg16807','Seed',0);
RandStream.setGlobalStream(s);

%default: sqrt(#features) (refer to the Supplementary file)
option.ntrees = ntree; %number of trees (default): 500
%% 10-cv
all_measureHet_RaF=zeros(p,8);
for va = 1:p                                  %# for each fold
    testIdx = (cvFolds == va);                %# get indices of test instances
    trainIdx = ~testIdx;
    %% Training Set
    trainX=dataTrainingX(trainIdx,:);
    trainY=dataTrainingY(trainIdx,:);
    %% Testing Set
    testX=dataTrainingX(testIdx,:);
    testY=dataTrainingY(testIdx,:);
    %% Separate the The two class in training data
    option.nvartosample = round(sqrt(size(trainX,2))); %random subspace (mtry) paramter
    %% model 1: Standrad RF
    %[Y1,train_tym,~]  = Oblique_RF(trainX,trainY,testX,testY,option);
    [acc,model1,Y1,train_tym]  = Oblique_RF(trainX,trainY,testX,testY,option)
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y1,2);
     all_measureHet_RaF(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
end % Gamma_Value
%% Save Results
output_struct.function_name='Het_RaF';
output_struct.dataset_name='Het_RaF';
output_struct.result_matrix=mean(all_measureHet_RaF);
output_struct.OptPara=model1;
output_struct.matter_type=validation_Index.matter_type;

output_struct.sel_features=validation_Index.sel_features;
[zz]=new_save_to_file(output_struct);

OptPara=1;
end
