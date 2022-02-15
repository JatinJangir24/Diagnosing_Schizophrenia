function pop = genOnevAll(unique_label)

numOfClass = length(unique_label);
pop = zeros(numOfClass,numOfClass);

for i=1:numOfClass 
    pop_temp = unique_label==unique_label(i);
    pop(i,:) = pop_temp;
end

end
%EOF