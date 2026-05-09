function [genvaluen] =gendeg(paramvalue,mins,maks,bit)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[r,c]=size(paramvalue);
for k=1:r
    for m=1:c

genvaluen(k,m)=(maks(1,m)-mins(1,m))*paramvalue(k,m)/((2^bit)-1)+mins(1,m);


    end
end


end