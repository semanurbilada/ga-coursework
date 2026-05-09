function [paramvalue, chromosomevalue] = createchrm(pop,parameternumber,bit)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[rw,cl]=size(pop);
for k=1:rw
    for p=1:parameternumber
        total=0;
        for b=1:bit
            param(p,b)=pop(k,p+(b-1)*parameternumber);
            total=total+pop(k,p+(b-1)*parameternumber)*(2^(b-1));
          
        end
        chromosomevalue(k,p,1:bit)=param(p,:);
        paramvalue(k,p)=total ; 
       end 
end



end