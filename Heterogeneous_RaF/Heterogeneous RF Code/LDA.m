function b = LDA(Input,Target)

delta = 0.01;

try
    % Determine size of input data
    [n,m] = size(Input);
    
    % Discover and count unique class labels
    ClassLabel = unique(Target);
    k = length(ClassLabel);
    
    % Initialize
    nGroup     = NaN(k,1);     % Group counts
    GroupMean  = NaN(k,m);     % Group sample means
    PooledCov  = zeros(m,m);   % Pooled covariance
    
    
    % Loop over classes to perform intermediate calculations
    for i = 1:k
        % Establish location and size of each class
        Group      = (Target == ClassLabel(i));
        nGroup(i)  = sum(double(Group));
        
        % Calculate group mean vectors
        GroupMean(i,:) = mean(Input(Group,:));
        
        % Accumulate pooled covariance information
        PooledCov = PooledCov + ((nGroup(i) - 1) / (n - k) ).* cov(Input(Group,:));
    end
    
    flag=rank(PooledCov)==size(PooledCov,1);
    diff = GroupMean(2,:)-GroupMean(1,:); %differences between means of two classes
    b = zeros(m+1,1);
    if flag==1 && norm(diff)~=0
        W = PooledCov\(diff)';
        bias = 0.5*W'*(GroupMean(2,:)+GroupMean(1,:))'-log(nGroup(2)/nGroup(1));
        %bias = 0.5*W'*(GroupMean(2,:)+GroupMean(1,:))';
        %Data_temp = Data*W;
        %[~,bias] = axis_parallel_cut(Label,Data_temp,minleaf);
        b(1:m) = W;
        b(end) = bias;
    else
        PooledCov = (PooledCov+delta*eye(size(PooledCov,1)));
        W = PooledCov\(diff)';
        bias = 0.5*W'*(GroupMean(2,:)+GroupMean(1,:))'-log(nGroup(2)/nGroup(1));
        %Data_temp = Data*W;
        %[~,bias] = axis_parallel_cut(Label,Data_temp,minleaf);
        b(1:m) = W;
        b(end) = bias;
    end
catch
    %warning('Problem computing Bhattacharya distance. Data cannot be separated.')
    b = zeros(size(Input,2)+1,1);
end

end

% EOF


