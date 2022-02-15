function B = decisionBoundaries_twoclass(Data,Label,minleaf)

B(:,1) = psvm(Data,Label,minleaf);
B(:,2) = logreg(Data,Label);
B(:,3) = LSSVM(Data,Label);
B(:,4) = SVM(Data,Label);
B(:,5) = RR(Data,Label,minleaf);
B(:,6) = LDA(Data,Label);
end

%EOF