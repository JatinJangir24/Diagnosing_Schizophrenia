function cNum = node_classifier(cNum_temp,l_num,totalnumofDec,numofDec2,numofDec3)



switch l_num
    
    case 'lda'
        range_mpsvm = 2:totalnumofDec-numofDec2-numofDec3+1;
        range_lssvm = range_mpsvm(end)+1:range_mpsvm(end)+numofDec2;
        
        if cNum_temp==1
            cNum = 'lda'; %LDA
        elseif any(ismember(range_mpsvm,cNum_temp))
            cNum = 'psvm'; %MPSVM
        elseif any(ismember(range_lssvm,cNum_temp))
            cNum = 'logreg';%Logreg
        else
            cNum = 'lssvm';%LSSVM
        end
        
    case 'psvm'
        range_lssvm = numofDec2+1:totalnumofDec;
        
        if cNum_temp==1
            cNum = 'psvm'; %MPSVM
        elseif any(ismember(range_lssvm,cNum_temp))
            cNum = 'logreg'; %LSSVM
        else
            cNum = 'lssvm'; %Logreg
        end
        
    case 'logreg'
        if cNum_temp==1
            cNum = 'logreg'; %MPSVM
        else
            cNum = 'lssvm'; %Logreg
        end
        
        
        
end
%EOF