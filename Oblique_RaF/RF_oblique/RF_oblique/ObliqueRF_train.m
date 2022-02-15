function [Random_Forest,Trainningtime ]= ObliqueRF_train(Data,Labels,varargin)
%modified from Leo's implementation.
%(http://www.mathworks.com/matlabcentral/fileexchange/31036-random-forest).
% Copyright (c) 2011, leo
% Copyright (c) 2006, Phillip M. Feldman
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
% Creates an ensemble of CARTrees using Data(samplesXfeatures).
%   The following parameters can be set :
%
%       ntrees       : number of trees in the ensemble (default 50)
%
%       oobe         : out-of-bag error calculation, 
%                      values ('y'/'n' -> yes/no) (default 'n')
%
%       nsamtosample : number of randomly selected (with
%                      replacement) samples to use to grow
%                      each tree (default num_samples)
%
%
%   Furthermore the following parameters can be set regarding the
%   trees themselves :

%       minleaf      : the minimum amount of samples in a leaf
%
%       weights      : a vector of values which weigh the samples 
%                      when considering a split
%
%       nvartosample : the number of (randomly selected) variables 
%                      to consider at each node 
%       'replace'    : whether use all the train data all sample withn
%       replacement.
%     
%                        
%      'oblique'   : How to search for the optimal hyperplane
%                         1: axis-parallel
%                         2: use Tikhonov regularization MPSVM when SSS 
%                         3: axis-parallev MPSVM when SSS
%                         4: subspace MPSVM when SSS
%                         5: PCA
%                         6. LDA
        
                        
okargs =   {'minparent' 'minleaf' 'nvartosample' 'ntrees' 'nsamtosample' 'method'  'replace' 'oblique'};
defaults = {2 1 round(sqrt(size(Data,2))) 50 numel(Labels) 'c'  1 1};
[eid,emsg,minparent,minleaf,m,nTrees,n,method,R,o] = getargs(okargs,defaults,varargin{:});

Trainningtime=0;

for i = 1 : nTrees
  
     
  
     if R==1
    TDindx = round(numel(Labels)*rand(n,1)+.5);
     else
         TDindx=1:numel(Labels);
     end
%    TDindx = unique(TDindx);
%     TDindx = randsample(numel(Labels),n,true);
%     TDindx = unique(TDindx);
   tic
    Random_ForestT = Obliquecartree_train(Data(TDindx,:),Labels(TDindx),TDindx, ...
        'minparent',minparent,'minleaf',minleaf,'method',method,'nvartosample',m,'oblique',o);
    Trainingtime_temp=toc;
    Trainningtime=Trainningtime+Trainingtime_temp;

if (mod(i,50) == 0) 
       if o==1
        fprintf([num2str(i),' decision tree generated in Random Forest with: axis-parallel\n ']);
       end
       if o==2
        fprintf([num2str(i),' decision tree generated in Random Forest with: MPSVM-Tikhonov regularization\n ']);
       end
       if o==3
        fprintf([num2str(i),' decision tree generated in Random Forest with: MPSVM-axis parallel regularization\n ']);
       end
       if o==4
        fprintf([num2str(i),' decision tree generated in Random Forest with: MPSVM-subspace regularization\n ']);
       end
       if o==5
        fprintf([num2str(i),' decision tree generated in Random Forest with: PCA\n ']);
       end
       if o==6
        fprintf([num2str(i),' decision tree generated in Random Forest with:LDA \n']);
       end
        
end
   
    Random_ForestT.method = method;

    Random_ForestT.oobe = 1;
  
        Random_Forest(i) = Random_ForestT; 
end