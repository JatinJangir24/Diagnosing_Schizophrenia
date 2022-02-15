function OptPara=Optimize_LSTWSVM(validation_Index)
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
    Range_gamma=2.^[-10:10]; % 15 values
else
    Range_gamma=1; % 15 values
end
p=validation_Index.p; % 10 fold cross validation
cvFolds=validation_Index.cvFolds;
temp_AUC=0;
for c1 =Range_C1 							%Iterate on 13 values of c1
    for gamma = Range_gamma     %Iterate on 13 values of c3
        %% 10-fold cross validation
        FunPara=struct('c1',c1,'kerfPara',struct('type',kern.type,'pars',gamma));
        %cvFolds = crossvalind('Kfold', size(dataTrainingX,1), p);   %# get indices of 10-fold CV of "groups" observation
        all_measure=zeros(p,8);
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
            [Predict_Y,train_tym]=LSTWSVM([testX, testY],[trainX, trainY],FunPara);
            [AUC accuracy sensitivity specificity precision f_measure gmean] = Evaluate(testY,Predict_Y',1);
            all_measure(va,:)=[accuracy AUC sensitivity specificity precision f_measure gmean train_tym];
        end % Gamma_Value
        if 	mean(all_measure(:,1)) >temp_AUC
            temp_AUC=mean(all_measure(:,1));
            OptPara=FunPara;
            OptPara.mean_accuracy=temp_AUC;
            OptPara.standard_dev=std(all_measure(:,1));
            OptPara.train_time=mean(all_measure(:,end));
            OptPara.all_measure=all_measure;
        end
        %         if accuracy==1% training accuracy reaches 100 percent no more updates to OptPara
        %             return
        %         end
    end
    disp(['LSTWSVM: c1=', num2str(c1),' Gamma= ', num2str(gamma),' Accuracy= ',num2str(temp_AUC)]);
end %for K i.e. C1
disp('Completed')

st = dbstack;
namestr = st.name;
output_struct.function_name=[namestr '_' kern.type];
output_struct.dataset_name=[namestr '_' kern.type];
output_struct.result_matrix=mean(OptPara.all_measure);
output_struct.OptPara=OptPara;
output_struct.matter_type=validation_Index.matter_type;

output_struct.sel_features=validation_Index.sel_features;
[zz]=new_save_to_file(output_struct);
%
% [test_accuracy,train_time]= TWSVM(testingData(:,1:end-1), testingData(:,end),ALLdataTrainingX(ALLdataTrainingY==1,:), ALLdataTrainingX(ALLdataTrainingY~=1,:),OptPara);
% OptPara.test_accuracy=test_accuracy;
% OptPara.train_time=train_time;
end