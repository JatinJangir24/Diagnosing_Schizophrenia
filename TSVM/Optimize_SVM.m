function OptPara=Optimize_SVM(validation_Index)
addpath(genpath("D:\Work\Projects\Tanveer\Schizophrenia\Schizophrenia_Project\libsvm-3.25\windows"));
ALLData=validation_Index.ALL_DATA;
[samples,~]=size(ALLData);
dataTrainingX=ALLData(:,1:end-1);
dataTrainingY=ALLData(:,end);
dataTrainingY(ALLData(:,end)==1)=-1;
dataTrainingY(ALLData(:,end)==2)=1;
%% All Parameters
kern.type=validation_Index.kern_type;
Range_C1=10.^[-5:5]; % 15 values
if strcmp(kern.type,'rbf')
    kern_type = 2;
    Range_gamma=2.^[-10:10]; % 15 values
else
    kern_type = 0;
    Range_gamma=1; % 15 values
end
p=validation_Index.p; % 10 fold cross validation
cvFolds=validation_Index.cvFolds;
all_measureSVM=zeros(p,8);
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
    tic
%     SVMModel = fitcsvm(trainX,trainY,'KernelFunction',kern.type,...
%         'BoxConstraint',Inf,'Standardize',true,'ClassNames',[-1,1]);
    SVMModel = svmtrain1(trainY,trainX, ['-s 1 -t ' num2str(kern_type)]);
    train_tym=toc;
    [Y1,~,~] = svmpredict1(testY,testX, SVMModel);
    
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y1,1);
    all_measureSVM(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
end % Gamma_Value
%% Save Results
output_struct.function_name='SVM';
output_struct.dataset_name='SVM';
output_struct.result_matrix=mean(all_measureSVM);
output_struct.OptPara=SVMModel;
output_struct.matter_type=validation_Index.matter_type;
output_struct.sel_features=validation_Index.sel_features;
[zz]=new_save_to_file(output_struct);

OptPara=1;
rmpath(genpath("D:\Work\Projects\Tanveer\Schizophrenia\Schizophrenia_Project\libsvm-3.25\windows"));
end
