function [Data_temp,Label_temp] = undersampling(Data,Label,dist,curClass)

[m,~] = size(Data);
unique_labels = unique(Label);

nearClass = find(dist==0); %classes in close vicinity of the class in consideration

%The samples are undersampled based on the Bhattacharya distance
%That means, weighting ratio is inverse of Bhattacharya distance
dist = abs(dist);
dist(nearClass) = 5; %a proxy step to perform inverse afterwards
dist = 1./dist;
dist(nearClass) = 0; %removing proxy distance 
dist = dist/sum(dist);

ir = 1.5;%fix imbalance ratio
origClassIndex = find(Label==unique_labels(curClass)); %number of samples in current class
len = length(origClassIndex);
num_restClasses = round(ir*len);

Data_temp = Data(origClassIndex,:);
Label_temp = Label(origClassIndex);

%create a rule when the class in consideration has more samples than rest classes
num_restSamples = m-len;

if len>num_restSamples
    
    Data_temp = Data;
    Label_temp = Label;
else
    
    
    for k = 1:length(unique_labels)
        
        if k==curClass
            continue
        end
        
        ClassIndex = find(Label==unique_labels(k));
        numSamples = round(dist(k)*num_restClasses);
        num = length(ClassIndex);
        
        if num>numSamples
            sampleIndex = randsample(ClassIndex,numSamples,false);
        else
            sampleIndex = ClassIndex;
        end
        
        Label_temp = [Label_temp;Label(sampleIndex)];
        Data_temp = [Data_temp;Data(sampleIndex,:)];
        
    end
end

end
%EOF
