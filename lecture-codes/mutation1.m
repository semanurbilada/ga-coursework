function [pop1] = mutation1(pop,best,pr)

[r,c]=size(pop);
pop1=pop;
uzunluk=r*c;
bitsay=round(pr*uzunluk);

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
r1=round(r*rand(1,bitsay));
c1=round(c*rand(1,bitsay));


for k=1:bitsay
    if r1(1,k)<1
        r1(1,k)=1;
    end
     if c1(1,k)<1
        c1(1,k)=1;
    end

    if pop1(r1(1,k),c1(1,k))==1
        pop1(r1(1,k),c1(1,k))=0;
    else
        pop1(r1(1,k),c1(1,k))=1;
    end
    
end
pop1(1,:)=best;
end 