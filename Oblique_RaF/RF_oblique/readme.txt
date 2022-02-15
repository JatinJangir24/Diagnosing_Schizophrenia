This code is modified from Leo's implementation .
(http://www.mathworks.com/matlabcentral/fileexchange/31036-random-forest. 
Copyright (c) 2011, leo
Copyright (c) 2006, Phillip M. Feldman
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.)

example: model=ObliqueRF_train(trainX,trainY,'ntrees',ntree,'nvartosample',mtry,'oblique',1);
         [Y,~]=ObliqueRF_predict(testX,model1);

other parameters are given below:

%       minleaf      : the minimum amount of samples in a leaf (default :0)
%

%
%       nvartosample : the number of (randomly selected) variables (default: square root of the feature dimension)
%                      to consider at each node 
%       'replace'    : whether use all the train data all sample withn
%        replacement.
%     
%                        
%       'oblique'   : How to search for the optimal hyperplane
%                         1: axis-parallel (default)   (reference [1])
%                         2: MPSVM + Tikhonov regularization (reference [3,4])
%                         3: MPSVM+ axis-parallel split(reference [3,4])
%                         4: MPSVM+ subspace split   (reference [3,4])
%                         5: PCA+ axis-parallel split (reference [2])
%                         6. LDA+ axis-parallel split(reference [2])

Reference: [1]. Breiman, Leo. "Random forests." Machine learning 45.1 (2001): 5-32.
           [2]. Zhang, Le, and Ponnuthurai Nagaratnam Suganthan. "Random forests with ensemble of feature spaces." Pattern Recognition 47.10 (2014): 3429-3437.
           [3]. Zhang, Le, and Ponnuthurai N. Suganthan. "Oblique Decision Tree Ensemble via Multisurface Proximal Support Vector Machine."  IEEE Transactions on Cybernetics, Year: 2015, Volume: PP, Issue: 99(2014).
           [4]. Zhang, Le, Suganthan, P.N., ¡°Oblique Decision Tree Ensemble via Multisurface Proximal Support Vector Machine: A comprehensive Evaluation¡±. Submitted for publication.


This code is not optimized for the efficiency. It is tested on Windows 7 and 8.1 with matlab 2010,2013 and 2014.

Please cite properly if you are using this code.

If you have problems about this software, please contact: lzhang027@e.ntu.edu.sg or zhangleuestc@gmail.com.

05/08/2015
       