function cNum = node_classifier_binary(cNum_indx)

if cNum_indx==1
    cNum = 'psvm';
elseif cNum_indx==2
    cNum = 'logreg';
elseif cNum_indx==3
    cNum = 'lssvm';
else
    cNum = 'lda';
end
    
    
    
    
    
end