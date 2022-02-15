function [acc,model,Y1,train_time]  = Oblique_RF(trainX,trainY,testX,testY,option)

tic
model = ObliqueRF_train(trainX,trainY,option);
train_time=toc;

Y1 = ObliqueRF_predict(testX,model);

acc = length(find(Y1==testY))/size(testY,1);

end




