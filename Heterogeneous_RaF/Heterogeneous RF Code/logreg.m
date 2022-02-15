function b = logreg(Input,Target)

Input = sparse(Input);
cl = train(Target,Input,'-q -s 0 -B 1');
b = cl.w; %weight and bias coefficients
b(end) = b(end)*-1;
b = b';

end
% EOF


