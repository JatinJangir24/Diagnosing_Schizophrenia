function [f_output, f_votes,Testingtime,Index]= ObliqueRF_predict(Data,Random_Forest)
Testingtime = 0;
oobe_flag = 0;
f_votes = zeros(numel(Random_Forest),size(Data,1)); 
oobe = zeros(numel(Random_Forest),1);

if nargout > 3 
    
    Index=cell(numel(Random_Forest),1);
end

for i = 1 : numel(Random_Forest)
    tic
    if nargout>3
        [f_votes(i,:),Index{i}] = cartree_predict(Data,Random_Forest(i));
    else
        f_votes(i,:) = cartree_predict(Data,Random_Forest(i));
    end
    Testingtime_temp=toc;
    Testingtime=Testingtime+Testingtime_temp;
    
    oobe(i) = Random_Forest(i).oobe;
end

switch lower(Random_Forest(1).method)
    case {'c','g'}
        [unique_labels,~,f_votes]= unique(f_votes);
        f_votes = reshape(f_votes,numel(Random_Forest),size(Data,1));
        [~, ind] = max(weighted_hist(f_votes,~oobe_flag+oobe_flag*oobe,numel(unique_labels)),[],1);
        f_output = unique_labels(ind);
        if (size(Data,1) ~= size(f_output,1))
            f_output = f_output' ;
            f_votes = f_votes';
        end
    case 'r'
        f_output = mean(f_votes,1);
    otherwise
        error('No idea how to evaluate this method');
end


end
