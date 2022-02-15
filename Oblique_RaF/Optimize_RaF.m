function OptPara=Optimize_RaF(validation_Index)
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

%% 10-cv
all_measureRaF=zeros(p,8);
all_measureMPRaF_T=zeros(p,8);
all_measureMPRaF_P=zeros(p,8);
all_measureMPRaF_N=zeros(p,8);
all_measureRaF_PCA=zeros(p,8);
all_measureRaF_LDA=zeros(p,8);

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
    mtry=round(sqrt(size(trainX,2)));
    %% model 1: Standrad RF
    [model1,train_tym]=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',1);
    [Y1,~]=ObliqueRF_predict(testX,model1);
    %accuracy1((i-1)*v+j)=length(find(Y1==testY))/length(cv_p);
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y1,2);
    all_measureRaF(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
    
    % model2:  PSVM-Tikhonov regularization .
    [model2,train_tym]=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',2);
    [Y2,~]=ObliqueRF_predict(testX,model2);
    %accuracy2((i-1)*v+j)=length(find(Y2==testY))/length(cv_p);
    
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y2,2);
    all_measureMPRaF_T(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
    
    %% model3:PSVM-axis parallel
    [model3,train_tym]=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',3);
    [Y3,~]=ObliqueRF_predict(testX,model3);
    %accuracy3((i-1)*v+j)=length(find(Y3==testY))/length(cv_p);
    
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y3,2);
    all_measureMPRaF_P(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
    %% model4: PSVM-subspace
    [model4,train_tym]=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',4);
    [Y4,~]=ObliqueRF_predict(testX,model4);
    %accuracy4((i-1)*v+j)=length(find(Y4==testY))/length(cv_p);
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y4,2);
    all_measureMPRaF_N(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
    
    [model5,train_tym]=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',5);
    [Y5,~]=ObliqueRF_predict(testX,model5);
    %accuracy5((i-1)*v+j)=length(find(Y5==testY))/length(cv_p);
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y5,2);
    all_measureRaF_PCA(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
    
    [model6,train_tym]=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',6);
    [Y6,~]=ObliqueRF_predict(testX,model6);
    %accuracy6((i-1)*v+j)=length(find(Y6==testY))/length(cv_p);
    [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Y6,2);
    all_measureRaF_LDA(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
end % Gamma_Value
output_struct.sel_features=validation_Index.sel_features;

%% Save Results
output_struct.function_name='RaF';
output_struct.dataset_name='RaF';
output_struct.result_matrix=mean(all_measureRaF);
output_struct.OptPara=model1;
output_struct.matter_type=validation_Index.matter_type;

[zz]=new_save_to_file(output_struct);
%%
output_struct.function_name='MPRaF-T';
output_struct.dataset_name='MPRaF-T';
output_struct.result_matrix=mean(all_measureMPRaF_T);
output_struct.OptPara=model2;
output_struct.matter_type=validation_Index.matter_type;
[zz]=new_save_to_file(output_struct);
%%
output_struct.function_name='MPRaF-P';
output_struct.dataset_name='MPRaF-P';
output_struct.result_matrix=mean(all_measureMPRaF_P);
output_struct.OptPara=model3;
output_struct.matter_type=validation_Index.matter_type;
[zz]=new_save_to_file(output_struct);
%%
output_struct.function_name='MPRaF-N';
output_struct.dataset_name='MPRaF-N';
output_struct.result_matrix=mean(all_measureMPRaF_N);
output_struct.OptPara=model4;
output_struct.matter_type=validation_Index.matter_type;
[zz]=new_save_to_file(output_struct);
%%
output_struct.function_name='RaF-PCA';
output_struct.dataset_name='RaF-PCA';
output_struct.result_matrix=mean(all_measureRaF_PCA);
output_struct.OptPara=model5;
output_struct.matter_type=validation_Index.matter_type;
[zz]=new_save_to_file(output_struct);
%%
output_struct.function_name='RaF-LDA';
output_struct.dataset_name='RaF-LDA';
output_struct.result_matrix=mean(all_measureRaF_LDA);
output_struct.OptPara=model6;
output_struct.matter_type=validation_Index.matter_type;
[zz]=new_save_to_file(output_struct);


OptPara=1;
end
