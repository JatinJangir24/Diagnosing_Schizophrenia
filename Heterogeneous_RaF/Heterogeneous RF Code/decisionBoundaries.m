function B = decisionBoundaries(Data,Label,minleaf,o)

switch o
    case 'psvm'
        B = psvm(Data,Label,minleaf);
        
    case 'lssvm'
        B = LSSVM(Data,Label);
        
    case 'logreg'
        B = logreg(Data,Label);
        
    case 'svm'
        B = SVM(Data,Label);
        
    case 'rr'
        B = RR(Data,Label,minleaf);
end

end