pop=genhav(40,7,8);
[paramvalue, chromosomevalue] = createchrm(pop,7,8);
[genvaluen] =gendeg(paramvalue,[0,-5,0,-5,0,0,-2],[10,5,100,3,10,10,2],8);
[bstscore,score,bestchr,prmbest,pop1] = fitnesscalc(genvaluen,pop,yexp);
epoch=1;
%while (bstscore<10 || epoch<100) 
    while ( epoch<1000) 
    epoch = epoch + 1 % Increment the epoch counter
    [pop1] = crossover(pop,bestchr);
    [pop2] = mutation1(pop1,bestchr,0.01);
    [paramvalue, chromosomevalue] = createchrm(pop2,7,8);
    [genvaluen] =gendeg(paramvalue,[0,-5,0,-5,0,0,-2],[10,5,100,3,10,10,2],8);
    [bstscore,score,bestchr,prmbest,pop3] = fitnesscalc(genvaluen,pop2,yexp);

    pop=pop3;
    skor(epoch)=bstscore;

    end
    %%%%%

a=prmbest(1);
b=prmbest(2);
K=prmbest(3);
m=prmbest(4);
p=prmbest(5);
r1=prmbest(6);
f=prmbest(7);
ygenc4=a*t1+b+K*exp(-m*((t1-p)/r1).^2).*cos(2*pi*f*t1);
plot(t1,ygenc4)