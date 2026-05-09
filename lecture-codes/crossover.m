function [pop1] = crossover(pop,best)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[r,c]=size(pop);
A=[1:r];
pop1=pop;
bestindx=floor(r*rand());
if bestindx<1
    bestindx=1;
end
s1=round(0.8*r*rand());
if s1<1
    s1=1;
end
lng=fix(r/8);
 s2=s1+lng;
if s2>c
    s2=c;
end 
A1=randperm(r);
ust=floor(r/2);
for k=1:ust
    parent1=pop(A1(1,2*k-1),:);
    parent2=pop(A1(1,2*k),:);
    offspr1=parent1;
    offspr1(1,s1:s2)=parent2(1,s1:s2);
    offspr2=parent2;
    offspr2(1,s1:s2)=parent1(1,s1:s2);
    pop1(2*k-1,:)=offspr1;
    pop1(2*k,:)=offspr2;
   


end
pop1(bestindx,:)=best;
end