
function [y]=fft64(x);
% initialization
x = zeros([64,1]);
x1 = zeros([64,1]);
x2 = zeros([64,1]);
x3 = zeros([64,1]);
x4 = zeros([64,1]);
x5 = zeros([64,1]);
x6 = zeros([64,1]);
y  = zeros([64,1]);
n = zeros([64,6]);

for mm = 0:1:63
	x(mm+1) = 3*sin(16*pi*mm/64)+24*sin(2*pi*mm/64)+8*sin(6*pi*mm/64);
end

%stage 1
for mm = 0:1:31
    twiddle = exp(-2*pi*1i*mm*1/64);
    x1(mm+1) = x(mm+1) + x(mm+33);
    x1(mm+33) = (x(mm+1) - x(mm+33))*twiddle;
end

%stage 2
for mm = 0:1:15
   	twiddle=exp(-2*pi*1i*mm*1/32);
   	x2(mm+1)  = x1(mm+1) + x1(mm+17);
   	x2(mm+17)  = (x1(mm+1) - x1(mm+17))*twiddle;
   	x2(mm+33)  = (x1(mm+33) + x1(mm+49));
   	x2(mm+49)  = (x1(mm+33) - x1(mm+49))*twiddle;
end

%stage 3
for mm = 0:1:7
   	twiddle=exp(-2*pi*1i*mm*1/16);
   	x3(mm+1)  = x2(mm+1)  + x2(mm+9);
   	x3(mm+9)  = (x2(mm+1) - x2(mm+9))*twiddle;
   	x3(mm+17)  = (x2(mm+17) + x2(mm+25));
   	x3(mm+25)  = (x2(mm+17) - x2(mm+25))*twiddle;
   	x3(mm+33)  = (x2(mm+33) + x2(mm+41));
   	x3(mm+41)  = (x2(mm+33) - x2(mm+41))*twiddle;  
   	x3(mm+49)  = (x2(mm+49) + x2(mm+57));
   	x3(mm+57)  = (x2(mm+49) - x2(mm+57))*twiddle; 	
end

%stage 4
for mm = 0:8:56
	twiddle=exp(-2*pi*1i*1/8);
	x4(mm+1)  = x3(mm+1)  + x3(mm+5);
   	x4(mm+5)  = (x3(mm+1) - x3(mm+5));
   	x4(mm+2)  = (x3(mm+2) + x3(mm+6));
   	x4(mm+6)  = (x3(mm+2) - x3(mm+6))*twiddle;
   	x4(mm+3)  = (x3(mm+3) + x3(mm+7));
   	x4(mm+7)  = (x3(mm+3) - x3(mm+7))*twiddle^2;  
   	x4(mm+4)  = (x3(mm+4) + x3(mm+8));
   	x4(mm+8)  = (x3(mm+4) - x3(mm+8))*twiddle^3;
end  

%stage 5
for mm = 0:4:60
	twiddle=exp(-2*pi*1i*1/4);
	x5(mm+1) = x4(mm+1)  + x4(mm+3);
	x5(mm+3) = x4(mm+1) - x4(mm+3);
	x5(mm+2) = x4(mm+2) + x4(mm+4);
	x5(mm+4) = (x4(mm+2) - x4(mm+4))*twiddle;
end      

%stage 6
for mm = 0:2:62
	x6(mm+1) = x5(mm+1) + x5(mm+2);
	x6(mm+2) = x5(mm+1) - x5(mm+2);
end


%reorder
for mm = 1:1:64
	aa=mm-1;
	bb=0;
	
	for nn = 1:1:6
		r=mod(aa,2);
        aa=floor(aa./2);
		bb = bb*2+r;
	end
	y(mm)=x6(bb+1);
end

n(1:64,1)=x1;
n(1:64,2)=x2;
n(1:64,3)=x3;
n(1:64,4)=x4;
n(1:64,5)=x5;
n(1:64,6)=x6;
disp(x);
disp(n);

t = 0:1:63;

figure(1);
	plot(t,x);
	title('Sine waves with non different amplitudes');
	xlabel('Time(s)');
	ylabel('Amplitude');

figure(2);
	plot(t,abs(y));
	title('FFT output');
	xlabel('Frequency');
	ylabel('Amplitude');
    
figure(3);
plot(t,abs(x6));
title('Bit reversed dif fft')
