function [bstscore,score,bestchr,prmbest,pop1] = fitnesscalc(genvaluen,pop)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[r,c]=size(genvaluen)
for k=1:r
    score(k)=exp(-((genvaluen(k,1))^2+(genvaluen(k,2))^2));
end

[srtscore,indx]=sort(score)

bestchr=pop(indx(r),:);
prmbest=genvaluen(indx(r),:);
worstchr=pop(indx(1),:);
prmworst=genvaluen(indx(1),:);
pop1=pop;
pop1(indx(1),:)=bestchr;
bstscore=srtscore(r);
indx=indx
end