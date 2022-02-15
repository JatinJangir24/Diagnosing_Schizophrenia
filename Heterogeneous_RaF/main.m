%% Train the Random Forest
% For information about using this dataset, refer to Dalgado's paper and
% codes

%If you find any bugs/issues, please contact
% Rakesh (rakeshku001@e.ntu.edu.sg)

clear
clc

annealing_train_R;
annealing_test_R;

addpath(genpath(pwd))

data = [data1;data2];
N = size(data1,1);
data = data(:,2:end);
dataX = data(:,1:end-1);
dataY = data(:,end);

% class labels should start from 1
class = unique(dataY);
if class(1)==0
    dataY = dataY+1;
end

mean_X = mean(dataX,1);
dataX = bsxfun(@rdivide,dataX-repmat(mean_X,size(dataX,1),1),std(dataX));

s = RandStream('mcg16807','Seed',0);
RandStream.setGlobalStream(s);

option.nvartosample = round(sqrt(size(dataX,2))); %default;
option.ntrees = 500;

annealing_conxuntos_kfold;

n = 4;
ACC = zeros(1,n);
Model_tree = cell(1,n);


for i = 1:4
    
    trainX=dataX(index{2*i-1},:);
    trainY=dataY(index{2*i-1},:);
    testX=dataX(index{2*i},:);
    testY=dataY(index{2*i},:);
    
    [ACC(1,i),Model_tree{1,i}]  = Oblique_RF(trainX,trainY,testX,testY,option)
    
end

Accuracy = mean(ACC,2)

option.testAcc = Accuracy;
option.TrainedModel = Model_tree;



