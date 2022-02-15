function OptPara=Optimize_SVM(validation_Index, sel_features,Data_1)
%% All Parameters
kern.type=validation_Index.kern_type;
Range_C1=10.^[-5:5]; % 15 values
if strcmp(kern.type,'rbf')
    Range_gamma=2.^[-10:10]; % 15 values
else
    Range_gamma=1; % 15 values
end
p=validation_Index.p;
cvFolds=validation_Index.cvFolds;
all_measureSVM=zeros(p,8);
for va = 1:p                                  %# for each fold
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(validation_Index.matter_type,'WM')
        %Data=Data_1.ROI.WM;
        Data=Data_1.Voxel.WM;
    elseif strcmp(validation_Index.matter_type,'GM')
        %Data=Data_1.ROI.GM;
        Data=Data_1.Voxel.GM;
    else
        %         DataWM=Data_1.ROI.WM;
        %         DataGM=Data_1.ROI.GM;
        DataWM=Data_1.Voxel.WM;
        DataGM=Data_1.Voxel.GM;
    end
    Labels=Data_1.Status;
    %% Feature Selection
    validation_Index.sel_features=sel_features;
    if ~strcmp(validation_Index.matter_type,'Combined')
        [IDX1,Z1]=rankfeatures(Data',Labels');
        ALL_DATA=[Data(:,IDX1(1:sel_features)),Labels];
    else
        [IDX1,Z1]=rankfeatures(DataWM',Labels');
        [IDX2,Z2]=rankfeatures(DataGM',Labels');
        ALL_DATA=[DataWM(:,IDX1(1:sel_features)),DataGM(:,IDX2(1:sel_features)),Labels];
    end
    ALLData=ALL_DATA(validation_Index.perm_index,:);
    
    [samples,~]=size(ALLData);
    dataTrainingX=ALLData(:,1:end-1);
    dataTrainingY=ALLData(:,end);
    dataTrainingY(ALLData(:,end)==1)=-1;
    dataTrainingY(ALLData(:,end)==2)=1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    SVMModel = fitcsvm(trainX,trainY,'KernelFunction',kern.type,...
        'BoxConstraint',Inf,'Standardize',true,'ClassNames',[-1,1]);
    train_tym=toc;
    [Y1,score] = predict(SVMModel,testX);
    
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
end
