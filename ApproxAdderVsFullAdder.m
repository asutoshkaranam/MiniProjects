%in=[100 230 132 234 98 56; 178 145 124 213 200 80; 12 0 13 4 198 205];
in1=imread('C:\Program Files\MATLAB\R2016b\toolbox\images\imdata\cameraman.tif');
in1=imresize(in1, [128 128]);
in=imnoise(in1,'salt & pepper',0.2)
out=replicate(in);
thanks=zeros(128,128);
v=1;
for i=1:128
    for j=1:128
        thanks(i,j)=ceil(out(v));
        v=v+1;
    end
end

%replicate function
function final= replicate(arr)
siz=size(arr);
n1=siz(1)+2;
n2=siz(2)+2;
result=zeros(n1,n2);
for i=2:(n1-1)
    for j=2:(n2-1)
        result(i,j)=arr(i-1,j-1);
    end
end
result(1,1)=arr(1,1);
result(1,n2)=arr(1,n2-2);
result(n1,1)=arr(n1-2,1);
result(n1,n2)=arr(n1-2,n2-2);
for i=2:n2-1
    result(1,i)=arr(1,i-1);
end
for i=2:n2-1
    result(n1,i)=arr(n1-2,i-1);
end
for i=2:n1-1
    result(i,1)=arr(i-1,1);
end
for i=2:n1-1
    result(i,n2)=arr(i-1,n2-2);
end

%disp(result);
b=zeros(3,3);
xindex=1;
yindex=1;
a=zeros(9,8);
%key=1;
final=zeros((n1-2)*(n2-2));
count=1;
for k=1:((n1-2)*(n2-2))
   in=1;
   jn=1;
   key=1;
   for i=xindex:(xindex+2)
       for j=yindex:(yindex+2)
          b(in,jn)=result(i,j);
          jn=jn+1;
       end
       in=in+1;
       jn=1;
   end
   for i=1:3
       for j=1:3
           a(key,1:8)=de2bi(b(i,j),8);
           key=key+1;
       end
   end
   
   final(count)=meancal(a(1,1:8),a(2,1:8),a(3,1:8),a(4,1:8),a(5,1:8),a(6,1:8),a(7,1:8),a(8,1:8),a(9,1:8));
    if (yindex <= (n2-3))
        yindex=yindex+1;
    else
        xindex=xindex+1;
        yindex=1;
   
    end
    count=count+1;
end

end

%mean calculator
function val=meancal(inp1,inp2,inp3,inp4,inp5,inp6,inp7,inp8,inp9)
[sum,carry1]=eightadd(inp1,inp2); 
[sum,carry2]=eightadd(sum,inp3);
[sum,carry3]=eightadd(sum,inp4);
[sum,carry4]=eightadd(sum,inp5);
[sum,carry5]=eightadd(sum,inp6);
[sum,carry6]=eightadd(sum,inp7);
[sum,carry7]=eightadd(sum,inp8);
[sum,carry8]=eightadd(sum,inp9);
[carrysum1,carrycar1]=approfulladd(carry1,carry2,carry3);
[carrysum2,carrycar2]=approfulladd(carry4,carry5,carry6);
[carrysum3,carrycar3]=approhalfadd(carry7,carry8);
[carrysumn,carry]=approfulladd(carrysum1,carrysum2,carrysum3);
[carrysum,carr]=approfulladd(carrycar1,carrycar2,carrycar3);
[carsu,car]=approhalfadd(carrysum,carry);
resul=[car carsu carrysumn sum];
%resul=fliplr(resul);
val=bi2de(resul);
val=val/9;
end

%approximate half adder
function [sum carry] = approhalfadd(bin1,bin2)
sum=xor(bin1,bin2);
carry=and(bin1,bin2);
end

%approximate full adder
function [sumf carryf] = approfulladd(binf1,binf2,binf3)
w=xor(binf1,binf2);
ww=and(binf1,binf3);
www=and(binf2,binf3);
wwww=and(binf3,binf1);
ddd=or(ww,www);
sumf=xor(w,binf3);
carryf=or(ddd,wwww);
end

%eight adder
function [sumeight,carryeight] = eightadd(bitinp1,bitinp2)
for i = 1:8
    if(i>1)
        [sumeight(i),carryeight]=approfulladd(bitinp1(i),bitinp2(i),carryeight);
    else
        [sumeight(i),carryeight]=approhalfadd(bitinp1(i),bitinp2(i));
    end
end
end
