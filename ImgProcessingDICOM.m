A=dicomread('image_CT.dcm')
info=dicominfo('image_CT.dcm')
J=dicomread(info);
%imshow(J,'DisplayRange',[])
I=imresize(A, [64 64]);
d=[];
f=[];
p=[];
g=[];
w=[];
e=[];
h=[];
num=0;
%GENERATION OF PN SEQUENCES 
G=16;                             % Code length
sd1=[1 0 1 0];                    % Initial state of Shift register
PN=[];                            % First PN-sequence
for j=1:G        
    PN=[PN sd1(4)];
    if sd1(1)==sd1(3)
        temp=0;
    else temp=1;
    end
    sd1(1)=sd1(2);
    sd1(2)=sd1(3);
    sd1(3)=sd1(4);
    sd1(4)=temp;
end;
sd2=[0 1 0 0];                    % Initial state of Shift register
PN1=[];                            % SECOND PN-sequence
for j=1:G        
    PN1=[PN1 sd2(4)];
    if sd2(1)==sd2(3)
        temp1=0;
    else temp1=1;
    end
    sd2(1)=sd2(2);
    sd2(2)=sd2(3);
    sd2(3)=sd2(4);
    sd2(4)=temp1;
end;

            
%IMAGE to be xor'ed with 2 sets of psuedo noise sequenceS


for m=1:64
    for n=1:64
        if m%2==0
            a=de2bi((I(m,n)),16,'left-msb');
            c=xor(a,PN);
            d=bi2de(c,'left-msb');
            f(m,n)=d;
        else
            a=de2bi((I(m,n)),16,'left-msb');
            c=xor(a,PN1);
            d=bi2de(c,'left-msb');
            f(m,n)=d;
        end
    end
end
f=uint16(f);
%HANDLINGNOISE-poisson

q =imnoise(f,'poisson'); 
gauss=imnoise(f,'gaussian',0,0.025);
imno=imnoise(I,'poisson')
w = medfilt2(q);
e= wiener2(q,[1 2]);
c = imgaussfilt(gauss);
v= wiener2(gauss,[1 2]);
imfilt=wiener2(imno,[1 2])

%DE-CRYPTION OF THE ORIGINAL IMAGE 

for m=1:64
    for n=1:64
        if m%2==0
            x=de2bi((f(m,n)),16,'left-msb');
            y=xor(x,PN);
            z=bi2de(y,'left-msb');
            p(m,n)=z;
        else
            x=de2bi((f(m,n)),16,'left-msb');
            y=xor(x,PN1);
            z=bi2de(y,'left-msb');
            p(m,n)=z;
        end
    end
end

%DECRYPTION OF MEDIAN FILTERED IMAGE

for m=1:64
    for n=1:64
      
        if m%2==0
            x=de2bi((w(m,n)),16,'left-msb')
            y=xor(x,PN)
            z=bi2de(y,'left-msb')
            g(m,n)=z
        else
            x=de2bi((w(m,n)),16,'left-msb')
            y=xor(x,PN1)
            z=bi2de(y,'left-msb')
            g(m,n)=z
        end
    end
end
g=uint16(g)
%DECRYPTION OF WIENER FILTERED IMAGE

for m=1:64
    for n=1:64
      
        if m%2==0
            x=de2bi((e(m,n)),16,'left-msb')
            y=xor(x,PN)
            z=bi2de(y,'left-msb')
            h(m,n)=z
        else
            x=de2bi((e(m,n)),16,'left-msb')
            y=xor(x,PN1)
            z=bi2de(y,'left-msb')
            h(m,n)=z
        end
    end
end
h=uint16(h)
%gaussian noise
%gaussfilt
for m=1:64
    for n=1:64
      
        if m%2==0
            x=de2bi((c(m,n)),16,'left-msb')
            y=xor(x,PN)
            z=bi2de(y,'left-msb')
            r(m,n)=z
        else
            x=de2bi((c(m,n)),16,'left-msb')
            y=xor(x,PN1)
            z=bi2de(y,'left-msb')
            r(m,n)=z
        end
    end
end
r=uint16(r)

%DECRYPTION OF WIENER FILTERED IMAGE

for m=1:64
    for n=1:64
      
        if m%2==0
            x=de2bi((v(m,n)),16,'left-msb')
            y=xor(x,PN)
            z=bi2de(y,'left-msb')
            wiga(m,n)=z
        else
            x=de2bi((v(m,n)),16,'left-msb')
            y=xor(x,PN1)
            z=bi2de(y,'left-msb')
            wiga(m,n)=z
        end
    end
end
wiga=uint16(wiga)

numwi=biterr(h,I);
nummed=biterr(g,I);
numgwi=biterr(r,I);
numgmed=biterr(wiga,I);
numfilt=biterr(imfilt,I);

for i=1:64          %DISPLAY THE positions modified
    for j=1:64 
        if(I(i,j)~=e(i,j))
            %disp(i);
            x =sprintf('the positions are %d %d\n',i,j);
           
        end
    end
end






subplot(5,2,1);
imshow(I,[]);
title('original');
subplot(5,2,2);

imshow(f,[]);
title('encrypted');
subplot(5,2,3);
imshow(q,[]);
title('noisy');

subplot(5,2,4);

imshow(w,[]);
title('median filtered');
subplot(5,2,5);

imshow(e,[]);
title('wiener filtered');
subplot(5,2,6);

imshow(p,[]);
title('decrypted-original');
subplot(5,2,7);

imshow(g,[]);
title('decrypted2-median filtered');
subplot(5,2,8)
imshow(h,[]);
title('decrypted - wiener filtered');
subplot(5,2,9)
imshow(imfilt,[])
title('filtered original attacked image')


%x-shows positions of error
%num-shows no.of error
%q-niose image
%w-median filtered
%e-wiener filtered
%g-decrypted median
%h-wiener median







