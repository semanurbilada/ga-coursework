function [pop] = genhav(chromosomenumber,parameternumber,bit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    uzunluk=parameternumber*bit;
for k=1:chromosomenumber
    for m=1:uzunluk
        chromosome(k,m)=round(rand());
    end
end

pop=chromosome; 
end