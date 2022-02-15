%% Use the pre-trained Random Forest to predict
% For information about using this dataset, refer to Dalgado's paper and
% codes


clear
clc

load trained_RandomForest.mat
Model_tree = option.TrainedModel;

annealing_train_R;
annealing_test_R;

addpath(genpath(pwd))

data = [data1;data2];
N = size(data1,1);
data = data(:,2:end);
dataX = data(:,1:end-1);
dataY = data(:,end);

class = unique(dataY);
if class(1)==0
    dataY = dataY+1;
end

mean_X = mean(dataX,1);
dataX = bsxfun(@rdivide,dataX-repmat(mean_X,size(dataX,1),1),std(dataX));

s = RandStream('mcg16807','Seed',0);
RandStream.setGlobalStream(s);

annealing_conxuntos_kfold;

n = 4;
ACC = zeros(1,n);

for i = 1:4
    
    testX=dataX(index{2*i},:);
    testY=dataY(index{2*i},:);
    
    model = Model_tree{1,i};
    
    pred = ObliqueRF_predict(testX,model);
    
    ACC(1,i) = length(find(pred==testY))/size(testY,1);
    
end

Accuracy = mean(ACC,2)*100





