function [indx, TestingAccuracy] = RVFLAE_predict(testX, testY, Model)

    beta1 = Model.beta1;
    beta = Model.beta;
    l3 = Model.l3;

    testX = zscore(testX')';

    H1 = testX * beta1;
    H1 = radbas(H1 * l3); % changed from tansig()
    H1 = [testX H1];
    rawScore = H1 * beta;

    %softmax to generate probabilites
    rawScore_temp1 = bsxfun(@minus, rawScore, max(rawScore, [], 2));
    num = exp(rawScore_temp1);
    dem = sum(num, 2);
    prob_scores = bsxfun(@rdivide, num, dem);
    [max_prob, indx] = max(prob_scores, [], 2);
    % [~, ind_corrClass] = max(testY, [], 2);
    TestingAccuracy = mean(indx == testY);

end
