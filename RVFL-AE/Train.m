function [Model,TrainAcc,TestAcc]  = Train(trainX,trainY,testX,testY,option)

% Train RVFL
[Model,TrainAcc] = RVFLAE_train(trainX,trainY,option);

% Using trained model, predict the testing data
TestAcc = RVFLAE_predict(testX,testY,Model);

end
%EOF