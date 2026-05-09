function [bstscore1,bstscore,score,bestchr,prmbest,pop1] = fitnesscalc(genvaluen,pop,inp,out)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[r,c]=size(genvaluen);
%t=[0:0.01:20];
A1=zeros(3,3);
A2=zeros(3,3);
A3=zeros(3,3);
A4=zeros(3,3);
P=inp;
ken=out;
for k=1:r
   A1(1,1) =genvaluen(k,1);
   A1(1,2) =genvaluen(k,2);
   A1(1,3) =genvaluen(k,3);
   A1(2,1) =genvaluen(k,4);
   A1(2,2) =genvaluen(k,5);
   A1(2,3) =genvaluen(k,6);
   A1(3,1) =genvaluen(k,7);
   A1(3,2) =genvaluen(k,8);
   A1(3,3) =genvaluen(k,9);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   A2(1,1) =genvaluen(k,10);
   A2(1,2) =genvaluen(k,11);
   A2(1,3) =genvaluen(k,12);
   A2(2,1) =genvaluen(k,13);
   A2(2,2) =genvaluen(k,14);
   A2(2,3) =genvaluen(k,15);
   A2(3,1) =genvaluen(k,16);
   A2(3,2) =genvaluen(k,17);
   A2(3,3) =genvaluen(k,18);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55 

   A3(1,1) =genvaluen(k,19);
   A3(1,2) =genvaluen(k,20);
   A3(1,3) =genvaluen(k,21);
   A3(2,1) =genvaluen(k,22);
   A3(2,2) =genvaluen(k,23);
   A3(2,3) =genvaluen(k,24);
   A3(3,1) =genvaluen(k,25);
   A3(3,2) =genvaluen(k,26);
   A3(3,3) =genvaluen(k,27);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   A4(1,1) =genvaluen(k,28);
   A4(1,2) =genvaluen(k,29);
   A4(1,3) =genvaluen(k,30);
   A4(2,1) =genvaluen(k,31);
   A4(2,2) =genvaluen(k,32);
   A4(2,3) =genvaluen(k,33);
   A4(3,1) =genvaluen(k,34);
   A4(3,2) =genvaluen(k,35);
   A4(3,3) =genvaluen(k,36);

C1 = conv2(P, A1, 'same');
C2 = conv2(P, A2, 'same');
C3 = conv2(P, A3, 'same');
C4 = conv2(P, A4, 'same');

[rp, cp] = size(P);
C = Cexp(2:rp+1, 2:cp+1);

%%%%%%%%%%%%%%%%%%%%%
sayac=0;
sayac1=0;
for x=1:512
    for y=1:512
        if ken(x,y)==255
            if abs(ken(x,y)-C(x,y))<10
                sayac=sayac+10;
            end
        else 
            if abs(ken(x,y)-C(x,y))<10
                sayac1=sayac1+1;
            end
        end
    end
end
     


%fark1=C-ken;

%sayac=abs(fark1<10);

%score(k)=sum(sayac(:));
score(k) = sayac+sayac1;
score1(k,:)=[sayac sayac1];
% Store the calculated score for the current individual
%fark=sumsqr(fark1);

%%%%%%%%%%%%%%%%%%%%%%%%%%


 

  %%%%%%  yc=a*t+b+K*exp(-m*((t-p)/r1).^2).*cos(2*pi*f*t);
   %%%%%%%%% fark=yc-yexp;
    %score1(k) = fark;
    %score(k) = 1./(1+fark); % Calculate the score based on the squared error
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
bstscore1=score1(indx(r),:);

indx=indx;
end