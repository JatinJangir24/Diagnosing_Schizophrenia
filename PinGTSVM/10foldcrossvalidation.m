    clc;
    clear all;
    close all;
    file1 = fopen('result_pinballTWSVM_my(tau=1,r=0).txt','w+');
 %   file2 = fopen('results_c_mu_nonlinear.txt','w+');
   
    for load_file = 1:24 
    switch load_file
        case 1
           file='fertility'
                    test_start = 71;
        case 2
            file = 'iono',           
                    test_start = 247;     
        case 3
             file = 'Banknote',             
                    test_start = 961;   
        case 4
            file= 'votes'
                    test_start = 307;  
        case 5
            file= 'wpbc'           
                    test_start = 138;  
        case 6
            file= 'pima'           
                    test_start = 538;     
     
        case 7
           file= 'Ripley'       
                    test_start = 251;  
        case 8
           file= 'ndc1100'         
                    test_start = 771;     
        case 9
            file= 'cleve'
                    test_start = 178;     
        case 10
            file= 'ger'          
                    test_start = 801;    
        case 11
             file= 'aus'          
                    test_start = 541;  
        case 12
            file = 'haberman';
                    test_start = 201;  
        case 13
            file = 'transfusion';
                    test_start = 601;    
        case 14
            file = 'wdbc';
                    test_start = 501;   
             
        case 15
            file = 'splice';
                    test_start = 501;  
        case 16
            file = 'monk2';
                    test_start = 170; % its a special dataset, cant change test_size   
        case 17
            file = 'monk3';
                    test_start = 123; % its a special dataset, cant change test_size   
        case 18
            file = 'monks-1'; % its a special dataset, cant change test_size
                    test_start = 125;  
        case 19
            file = 'heart-stat';
                    test_start = 201; 
        case 20
            file= 'sonar'; 
                    test_start = 151;  
        case 21
            file= 'cmc';
                    test_start = 1001; 
        case 22
            file= 'crossplane150'; 
                    test_start = 81;
          
        case 23
            file= 'Heart-c';          
                    test_start = 178; 
        case 24
            file= 'ndc500';  %Only NDC datasets, we normalize in standard manner (not scalling)        
                    test_start = 501;  
        case 25
            file= 'ndc1k';          
                    test_start = 1001; 
        case 26
            file= 'ndc2k';          
                    test_start = 2001; 
        case 27
            file= 'ndc3k';          
                    test_start = 3001; 
        case 28
            file= 'ndc5k';          
                    test_start = 5001;        
        case 29
            file= 'ndc8k';          
                    test_start = 8001;   
        case 30
            file= 'ndc10k';          
                    test_start = 10001;
        case 31
            file= 'ndc50k';          
                    test_start = 50001;
        case 32
            file= 'twindata';          
                    test_start = 1001;
        case 33
            file= 'log_2';
                    test_start = 561;
        case 34
            file= 'shannon_2';
                    test_start = 561;
        case 35
            file= 'sure_2';
                    test_start = 561;
        case 36
            file= 'merged_2';
                    test_start = 561;
        case 37
            file= 'logsure_2';
                    test_start = 561;
        case 38
            file= 'shansure'
                    test_start = 561;
        case 39
            file='shanlog'
                    test_start = 561;
        case 40
            file='iris'
                    test_start = 106; 
                    
         case 41
           file='teachingeval'
                    test_start = 106;             
        case 42
           file='wine'
                    test_start = 126;           
        case 43
           file='Balance'
                    test_start = 126; 
         case 44
           file='seeds'
                    test_start = 181;          
         case 45
           file='hayes_roth'
                    test_start =91;          
         case 46
           file='image'
                    test_start =146; 
         case 47
           file='glass'
                    test_start =146;                 
         case 48
           file='statlog(vechile)'
                    test_start =597; 
         case 49
           file='lense'
                    test_start =17;
          case 50
           file='contraceptiv'
                    test_start =146;          
          case 51
           file='ecoli'
                    test_start =236;          
          case 52
           file='zoo'
                    test_start =71;
          case 53
           file='cleaveland'
                    test_start =211;           
          case 54
           file='newthyroid'
                    test_start =151;
          case 55
           file='tae'
                    test_start =106;
          case 56
           file='determalogy'
                    test_start =251;          
       otherwise
            continue;
    end   

                muvs=[2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5,2^6,2^7,2^8,2^9,2^10];
                cvs1=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
                cvs2=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
% %                 epls=[0.05,0.1,0.2,0.3,0.4];
% %                 nu1=[2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5];%%%%%%
% %                 nu2=[2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5];%%%%%%%%%%
% %                 muvs=1;cvs1=1; cvs3=1;nu1=1;nu2=1;Energy1=0.6;
                cvs2=cvs1;
% %                 nu1=nu2;%%%%%%%%%
%               cvs1= 10^-5;cvs2= 10^-5;muvs= 2^0;
                filename = strcat('C:\Users\manami bera\Desktop\anshul\Project\RELSTSVM\Dataset\',file,'.txt');
                A = load(filename);
                %A =  load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\Proposed Algorithm\Dataset\',file,'.txt') );
                [m,n] = size(A);
                TestX = A(test_start:m,:);
                if test_start > 1
                   DataTrain = A(1:test_start-1,:);        
                end  
                [m,n] = size(DataTrain);
% %                 DataTrain(:,1:n-1) = normalize(DataTrain(:, 1:n-1));
                DataTrain(:,1:n-1) = normalize(DataTrain(:, 1:n-1))+normrnd(0,0.5,m,n-1);%%%for noise
% %                 TestX(:,1:n-1) = normalize(TestX(:, 1:n-1));
                TestX(:,1:n-1) = normalize(TestX(:, 1:n-1))+normrnd(0,0.5,size(TestX,1),n-1);
                t = cputime;   
% % --------------------------------------------------------------------------     
     no_part = 10.;
%    initialize minimum error variable and corresponding c
    min_c1 = 1.;min_c2 = 1.;
% %     min_eplsion=1.;
% %     min_v1 = 1.;min_v2 = 1.;%%%%%%%%%%%%
% % min_c3=min_c1;min_c4=min_c2;
    min_err=10000000000.;
    min_mu=1.;
                for mui=1:length(muvs)
                    mu=muvs(mui);
                    for ci=1:length(cvs1)
                        c1=cvs1(ci);
                        for cii=1:length(cvs2)
                            c2=cvs2(cii);
% %                             for eplsi=1:length(epls)
% %                                 eplsion=epls(eplsi);
% %                               for vi=1:length(nu1)  
% %                                 v1=nu1(vi);
% %                                  for vii=1:length(v1)  
% %                                     v2=nu2(vii);
                                    block_size=m/(no_part*1.0);
                                    part=0;avgerr=0;t_1=0;t_2=0;
                                    while ((part+1)* block_size) <= m
                                        t_1 = ceil(part*block_size);
                                        t_2 = ceil((part+1)*block_size);                
                                        Data_test= DataTrain(t_1+1: t_2,:); 
                                        Data=[DataTrain(1:t_1,:); DataTrain(t_2+1:m,:)];
% %                                     c3=c1;c4=c2;
                                        FunPara.c1=c1;FunPara.c2=c2;
% %                                         FunPara.v1=v1;FunPara.v2=v2;
% %                                         FunPara.eplsion=eplsion;
                                        FunPara.kerfPara.pars=mu;
                                        FunPara.kerfPara.type = 'rbf';
                                        [acc,err] =pinballTWSVM_my(Data_test,Data,FunPara);
                                        %fprintf(file2, 'example file %s; err= %8.6g, part num= %8.6g, mu= %8.6g, c1= %8.6g, c2= %8.6g, c3= %8.6g, c4= %8.6g, E1= %8.6g, E2= %8.6g\n', file,err,part,mu,c1,c2,c3,c4,E1,E2);
                                        avgerr = avgerr + err;
                                        part=part+1;
                                    end
                                   % fprintf(file2, 'example no: %s\t avgerr: %g\t mu=%g\t c1=%g\t c2=%g c3=%g c4=%g E1=%g E2=%g \n',file, avgerr,mu,c1,c2,c3,c4,E1,E2);
                                    if avgerr < min_err
                                         min_c1 =c1;min_c2 =c2;
% %                                          min_eplsion=eplsion;
% %                                          min_v1 =v1;min_v2 =v2;
                                         min_err=avgerr;
                                         min_mu=mu;
                                        %%min_E1=E1;min_E2=E2;
                                 end  % for v2 
                             end  % for v1
                          end  %for c2 values
%                          end%for eplsi
                     end  % for c1 values 
% %                 end %for mu values
% %             end
   
               
%     final training
%    _______________________________________________________________________
    FunPara.c1=min_c1;FunPara.c2=min_c2;
% %     FunPara.eplsion=min_eplsion;
% %     FunPara.v1=min_v1;FunPara.v2=min_v2;
    FunPara.kerfPara.pars=min_mu;
    %%Energy.E1=min_E1;Energy.E2=min_E2;
    FunPara.kerfPara.type = 'rbf';
    [acc,err,Predict_Y,A,B,w1,b1,w2,b2]=pinballTWSVM_my(TestX,DataTrain,FunPara);
    fprintf(file1,'file: %s;acc = %8.6g,err = %8.6g,mu= %8.6g,c1 = %8.6g,c2 = %8.6g\n', file,acc,err,FunPara.kerfPara.pars,FunPara.c1,FunPara.c2);
    end
% % %     fclose(file1);
% %     file1=fopen('result_knnmulticlasstwsvm.txt','a+'); 
% %     fclose(file1);
% %  fclose(file2);
    
%................complete code.............................%    
                

    
   
    
    