function group_bhatta = group(Data)

unique_label=unique(Data(:,1));
DataX=Data(:,2:end);
DataY=Data(:,1);

[m,n]=size(DataX);
mean_data=zeros(length(unique_label),n);
variance_data=cell(1,length(unique_label));
distance=zeros(length(unique_label),length(unique_label));

for i=1:length(unique_label)
    index=find(DataY==unique_label(i));
    data_temp=DataX(index,:);
    mean_data(i,:)=mean(data_temp,1);
    %variance_data{i} = cov(data_temp);
    variance_data_temp = cov(data_temp);
    variance_data_temp(variance_data_temp==0) = 0.00001; 
    variance_data{i}=variance_data_temp;
    
end



for i=1:length(unique_label)
    for j=i+1:length(unique_label)
        
        
        if (rank(variance_data{i}+variance_data{j})==size(variance_data{i},1) )&& (size(variance_data{i},1)~=1 )&& (size(variance_data{i},1)~=1)
            
            distance(i,j)=((mean_data(i,:)-mean_data(j,:))/((variance_data{i}+variance_data{j})/2)*(mean_data(i,:)-mean_data(j,:))')/8+0.5*log(det((variance_data{i}+variance_data{j})/2)/sqrt(det(variance_data{i})*det(variance_data{j})));
            
        else
            distance(i,j)=norm(mean_data(i,:)-mean_data(j,:)) ;
        end
        distance(j,i)=distance(i,j);
    end
end

if ~any(distance(:))
    ind_shuffle = randperm(length(unique_label));
    numOfclass_group1 = round(0.5*length(unique_label));
    group1_temp_ind = ind_shuffle(1:numOfclass_group1);
    group1_temp = unique_label(group1_temp_ind);
    
    group2_temp =  setdiff(unique_label,group1_temp);
    
    distance = rand(length(unique_label),length(unique_label)); 
    
    index=find(distance==max(max(distance)));
    [I,J]=ind2sub(size(distance),index);
    group1=unique_label(I(1));
    group_bhatta.group1_extreme = group1;
    group2=unique_label(J(1));
    group_bhatta.group2_extreme = group2;
       
    group_bhatta.group1 = group1_temp;
    group_bhatta.group2 = group2_temp;
    group_bhatta.distance = distance;
    
else
    distance = abs(distance);
    index=find(distance==max(max(distance)));
    [I,J]=ind2sub(size(distance),index);
    group1=unique_label(I(1));
    group_bhatta.group1_extreme = group1;
    group2=unique_label(J(1));
    group_bhatta.group2_extreme = group2;
        
    for i=1:length(unique_label)
        
        d1=distance(I(1),i);
        d2=distance(J(1),i);
        if d1>=d2
            
            group2=[group2;unique_label(i)];
        else
            group1=[group1;unique_label(i)];
        end
        
        
    end
    [group1_temp,ind_1]=unique(group1);
    [group2_temp,ind_2]=unique(group2);
    
       
    group_bhatta.group1 = group1_temp;
    group_bhatta.group2 = group2_temp;
    group_bhatta.distance = distance;
end

end