P = imread('lenna.png');
P = rgb2gray(P);     % eğer renkliyse
P = double(P);

inp = P;

kenar = edge(uint8(inp), 'canny'); % hedef çıktı
out = 255 * kenar; %% desired output image
pop=genhav(40,36,4);
[paramvalue, chromosomevalue] = createchrm(pop,36,4);
[genvaluen] =gendeg(paramvalue,-5*ones(1,36),5*ones(1,36),4);
[bstscore1,bstscore,score,bestchr,prmbest,pop1] = fitnesscalc(genvaluen,pop,inp,out);
epoch=1;
%while (bstscore<10 || epoch<100) 
    while ( epoch<1000) 
    epoch = epoch + 1 % Increment the epoch counter
    [pop1] = crossover(pop,bestchr);
    [pop2] = mutation1(pop1,bestchr,0.01);
    [paramvalue, chromosomevalue] = createchrm(pop2,36,4);
    [genvaluen] =gendeg(paramvalue,-5*ones(1,36),5*ones(1,36),4);
    [bstscore1,bstscore,score,bestchr,prmbest,pop3] = fitnesscalc(genvaluen,pop2,inp,out);

    pop=pop3;
    skor(epoch)=bstscore;
    skor1(epoch,:)=bstscore1;
    a=bstscore1

    end
    %%%%%

B1=[prmbest(1) prmbest(2) prmbest(3);
    prmbest(4) prmbest(5) prmbest(6);
     prmbest(7) prmbest(8) prmbest(9)];

B2=[prmbest(10) prmbest(11) prmbest(12);
    prmbest(13) prmbest(14) prmbest(15);
     prmbest(16) prmbest(17) prmbest(18)];  

B3=[prmbest(19) prmbest(20) prmbest(21);
    prmbest(22) prmbest(23) prmbest(24);
     prmbest(25) prmbest(26) prmbest(27)];  

B4=[prmbest(28) prmbest(29) prmbest(30);
    prmbest(31) prmbest(32) prmbest(33);
     prmbest(34) prmbest(35) prmbest(36)];  



Cgen1=conv2(inp,B1);
mxc1=max(Cgen1(:));
mnc1=min(Cgen1(:));
Cgen1n=255*(Cgen1-mnc1)/(mxc1-mnc1);

Cgen2=conv2(inp,B2);
mxc2=max(Cgen2(:));
mnc2=min(Cgen2(:));
Cgen2n=255*(Cgen2-mnc2)/(mxc2-mnc2);

Cgen3=conv2(inp,B3);
mxc3=max(Cgen3(:));
mnc3=min(Cgen3(:));
Cgen3n=255*(Cgen3-mnc3)/(mxc3-mnc3);

Cgen4=conv2(inp,B4);
mxc4=max(Cgen4(:));
mnc4=min(Cgen4(:));
Cgen4n=255*(Cgen4-mnc4)/(mxc4-mnc4);
Cgen=0.25*(Cgen1n+Cgen2n+Cgen3n+Cgen4n);
figure
imshow(Cgen);

%%%t1=[0:0.5:20];
%%%t=[0:0.001:20];
%%%y1a=8*exp(-0.25*(((t1-4)./2).^2));
%%%y2a=cos(2*pi*0.52*t1);
%%%y3a=3*t1-2.7;
%%%yexp=y1a.*y2a+y3a;
%%a=prmbest(1);
%%b=prmbest(2);
%%K=prmbest(3);
%%m=prmbest(4);
%%p=prmbest(5);
%%r1=prmbest(6);
%%f=prmbest(7);
%%ygenc4=a*t1+b+K*exp(-m*((t1-p)/r1).^2).*cos(2*pi*f*t1);
%plot(t1,ygenc1)