function [model, TrainingAccuracy] = RVFLAE_train(trainX, trainY, option)
    % Prepared by Rakesh (rakeshku001@e.ntu.edu.sg).
    % A very simple implementation of AE initialized RVFL based on the paper
    % "An Unsupervised Parameter Learning Model for RVFL Neural Network" (neural network, 2019)
    % Instead of random weight initlization, the weights are computed using AE
    % You can change the activation function as you like
    
    U_trainY=unique(trainY);
    nclass=numel(U_trainY);
    trainY_temp=zeros(numel(trainY),nclass);
    % 0-1 coding for the target 
    for i=1:nclass
             idx= trainY==U_trainY(i);

             trainY_temp(idx,i)=1;
    end
    trainY = trainY_temp;
    [Nsample, Nfea] = size(trainX);
    N = option.N;
    C = option.C;

    %weights of hidden layers of AE
    w = 2 * rand(Nfea, N) - 1;
    %can add bias as in original rvfl

    trainX = zscore(trainX')';

    %% Autoencoder part
    A1 = trainX * w;
    A1 = radbas(A1); % changed from tansig()

    beta1 = sparse_l1_autoencoder(A1, trainX, 1e-3, 50)'; %l1-regulraization
    clear A1;

    %% RVFL intialized with AE weights
    %s = 0.8; %scaling factor
    s = 1; %scaling factor

    H1 = trainX * beta1;
    l3 = max(max(H1)); l3 = s / l3;
    H1 = radbas(H1 * l3); % changed from tansig()
    H1 = [trainX H1];

    if size(H1, 2) < Nsample
        beta = (eye(size(H1, 2)) / C + H1' * H1) \ H1' * trainY;
    else
        beta = H1' * ((eye(size(H1, 1)) / C + H1 * H1') \ trainY);
    end

    %% Calculate the training accuracy
    trainY_temp = H1 * beta;

    %softmax to generate probabilites
    trainY_temp1 = bsxfun(@minus, trainY_temp, max(trainY_temp, [], 2)); %for numerical stability
    num = exp(trainY_temp1);
    dem = sum(num, 2);
    prob_scores = bsxfun(@rdivide, num, dem);
    [max_prob, indx] = max(prob_scores, [], 2);
    [~, ind_corrClass] = max(trainY, [], 2);
    TrainingAccuracy = mean(indx == ind_corrClass);

    model.beta1 = beta1;
    model.beta = beta;
    model.l3 = l3;

end
