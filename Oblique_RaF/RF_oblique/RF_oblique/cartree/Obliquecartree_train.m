function RETree = Obliquecartree_train(Data1,Labels1,Index,varargin)
%RETree = cartree(Data,Labels,varargin)
%parameters that can be set are:
%       minleaf      : the minimum amount of samples in a leaf (default 1)
%       nvartosample : the number of (randomly selected) variables 
%                      to consider at each node (default all)


okargs =   {'minparent' 'minleaf' 'nvartosample' 'method'  'oblique' };
defaults = {2 1 round(sqrt(size(Data1,2))) 'c'  1};
[eid,emsg,minparent,minleaf,m,method,o] = getargs(okargs,defaults,varargin{:});
Data=Data1(Index,:);
Labels=Labels1(Index);
N = numel(Labels);
L = 2*ceil(N/minleaf) - 1;
M = size(Data,2);
nodeDataIndx = cell(L,1);
nodeDataIndx{1} = 1 : N;
nodevar=cell(L,1);
nodep=cell(L,1);
nodeCutVar = zeros(L,1);
nodeCutValue = zeros(L,1);
nodeflags = zeros(L+1,1);
nodelabel = zeros(L,1);
childnode = zeros(L,1);
nodeflags(1) = 1;


switch lower(method)
    case {'c','g'}
        [unique_labels,temp,Labels]= unique(Labels);
        max_label = numel(unique_labels);    
    otherwise
        max_label= [];
end

current_node = 1;
while nodeflags(current_node) == 1;
    
     currentDataIndx = nodeDataIndx{current_node};
    free_node = find(nodeflags == 0,1);
    if  numel(unique(Labels(currentDataIndx)))==1
        switch lower(method)
            case {'c','g'}
                nodelabel(current_node) = unique_labels(Labels(currentDataIndx(1)));
            case 'r'
                nodelabel(current_node) = Labels(currentDataIndx(1));
        end
        nodeCutVar(current_node) = 0;
        nodeCutValue(current_node) = 0;
        nodevar{current_node}=0;
        nodep{current_node}=0;
    else
        if numel(currentDataIndx)>2*minparent
             
             node_var = randperm(M);
             node_var = node_var(1:m);
                  
           
            
            
          
             X=Data(currentDataIndx,node_var);
          
         
               switch o
               case 1

                 [bestCutVar bestCutValue] =axis_parallel_cut(Labels(currentDataIndx),X,minleaf);
                 
                 if bestCutVar~=-1
                     b=zeros(m+1,1);
                 b(bestCutVar)=1;
                 b(end)=bestCutValue;
                 end
               
               case 2
                   Delta=0.01; 
              [bestCutVar, b] =hyperplane_psvm(X,Labels(currentDataIndx),1,minleaf,Delta);
              
              case 3
                   
              [bestCutVar, b] =hyperplane_psvm(X,Labels(currentDataIndx),2,minleaf);
            
             case 4
               [ bestCutVar,b]=hyperplane_psvm_subspace(X,Labels(currentDataIndx),minleaf);   
               
             case 5
               %  save temp X Labels currentDataIndx minleaf
               [bestCutVar, b] =hyperplane_pca(X,Labels(currentDataIndx),minleaf);      
             case 6
               [bestCutVar, b] =hyperplane_lda(X,Labels(currentDataIndx),minleaf); 
                
                  
               otherwise 
                   error('the method has not been implemented yet!')
                  
        
                       
               end  

            if bestCutVar~=-1
               nodeCutVar(current_node) = bestCutVar;
               nodevar{current_node}=node_var;
               nodep{current_node}=b;
               D=X*b(1:end-1);
              nodeDataIndx{free_node} = currentDataIndx(D<=b(end));
              nodeDataIndx{free_node+1} = currentDataIndx(D>b(end));
              nodeflags(free_node:free_node + 1) = 1;
              childnode(current_node)=free_node;
            else
                switch lower(method)
                    case {'c' 'g'}
                        [~, leaf_label] = max(hist(Labels(currentDataIndx),1:max_label));
                        nodelabel(current_node)=unique_labels(leaf_label);
                    case 'r'
                        nodelabel(current_node)  = mean(Labels(currentDataIndx));
                end
                
            end
        else
            switch lower(method)
                case {'c' 'g'}
                    [~, leaf_label] = max(hist(Labels(currentDataIndx),1:max_label));
                    nodelabel(current_node)=unique_labels(leaf_label);
                case 'r'
                    nodelabel(current_node)  = mean(Labels(currentDataIndx));
            end
        end
    end
    current_node = current_node+1;
end

RETree.nodeDataIndex=  nodeDataIndx(1:current_node-1);
RETree.p=nodep(1:current_node-1);
RETree.node_var=nodevar(1:current_node-1);
RETree.nodeCutVar = nodeCutVar(1:current_node-1);
RETree.childnode = childnode(1:current_node-1);
RETree.nodelabel = nodelabel(1:current_node-1);
RETree.dataindex=Index;
