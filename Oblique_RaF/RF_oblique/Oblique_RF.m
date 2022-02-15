clear;
clc;
load breast_cancer
dataX=full(dataX);
[m,n]=size(dataX);


%% decide the ensemble size of the trees ntry and the mtry for each tree mtry
ntree=100;

%% 15 10-cv 
M=5;% if M=20,it means 15 times v-fold validation.
v=4;% If v=4,it means 4-fold cross validation.
step=floor(m/v);
accuracy1=zeros(1,v*M);
accuracy2=zeros(1,v*M);
accuracy3=zeros(1,v*M);
accuracy4=zeros(1,v*M);
extra_options.replace=0;
extra_options.keep_inbag=1;
flag=0;
for i=1:M
    index=randperm(m);
for j =1:v
    if j~= v
        flag=flag+1
        startpoint=(j-1)*step+1;
        endpoint=(j)*step;
    else
        startpoint=(j-1)*step+1;
        endpoint=m;
    end
    cv_p=startpoint:endpoint; %%%% test set position
    
    %%%%%%%%%%%%%% test set
     testX=dataX(index(cv_p),:);
     testY= dataY(index(cv_p),:);  %%%%label
    %%%%%%%%%%%%%% training data
     trainX=dataX;
     trainX(index(cv_p),:)='';       
     trainY=dataY;
     trainY(index(cv_p),:)=''; 
     mtry=round(sqrt(size(trainX,2)));
       %% model 1: Standrad RF
     model1=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',1);
     [Y1,~]=ObliqueRF_predict(testX,model1);
     accuracy1((i-1)*v+j)=length(find(Y1==testY))/length(cv_p);

     % model2:  PSVM-Tikhonov regularization .
     model2=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',2);
     [Y2,~]=ObliqueRF_predict(testX,model2);
     accuracy2((i-1)*v+j)=length(find(Y2==testY))/length(cv_p);

     %% model3:PSVM-axis parallel
     model3=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',3);
     [Y3,~]=ObliqueRF_predict(testX,model3);
     accuracy3((i-1)*v+j)=length(find(Y3==testY))/length(cv_p);
     %% model4: PSVM-subspace
     model4=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',4);
     [Y4,~]=ObliqueRF_predict(testX,model4);
     accuracy4((i-1)*v+j)=length(find(Y4==testY))/length(cv_p);

      model5=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',5);
     [Y5,~]=ObliqueRF_predict(testX,model5);
     accuracy5((i-1)*v+j)=length(find(Y5==testY))/length(cv_p);
    
      model6=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',6);
     [Y6,~]=ObliqueRF_predict(testX,model6);
     accuracy6((i-1)*v+j)=length(find(Y6==testY))/length(cv_p);


    
end 
end

