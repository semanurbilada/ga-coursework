function [bstscore,score,bestchr,prmbest,pop1] = fitnesscalc(genvaluen,pop,yexp)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[r,c]=size(genvaluen);
t=[0:0.01:20];
A=zeros(3,3);

for k=1:r
    a11=genvaluen(k,1);


    b=genvaluen(k,2);
    K=genvaluen(k,3);
    m=genvaluen(k,4);
    p=genvaluen(k,5);
    r1=genvaluen(k,6);
    f=genvaluen(k,7);

    yc=a*t+b+K*exp(-m*((t-p)/r1).^2).*cos(2*pi*f*t);
    fark=yc-yexp;
    score1(k) = sum(fark.^2);
    score(k) = 1./(1+sum(fark.^2)); % Calculate the score based on the squared error
    % Calculate the score based on the squared error
    %score(k)=exp(-((genvaluen(k,1))^2+(genvaluen(k,2))^2));
end

[srtscore,indx]=sort(score);

bestchr=pop(indx(r),:);
prmbest=genvaluen(indx(r),:);
worstchr=pop(indx(1),:);
prmworst=genvaluen(indx(1),:);
pop1=pop;
pop1(indx(1),:)=bestchr;
bstscore=srtscore(r);
indx=indx
end