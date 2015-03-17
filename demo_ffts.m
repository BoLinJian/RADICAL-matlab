clear;
clc;
%t : 0 - 2, stepping 0.001, total 2001 pts
t=0:0.01:2;
T=max(t);
deltaF=1/T;
%total samples : pts
n=max(size(t));
%sampling freq = (n-1)/t
Fs=(n-1)/T;
%cosine working freq
Fw=5;

x=cos(2*pi*Fw*t);
figure;
plot(t, x);
title('cos(t) @5hz, T= 2s');

figure;
plot(x);
title('cos(n) @5hz, n=201 pts');

y1=fft(x);
y2=fftshift(y1);

freq=[0:n-1]*deltaF;

figure;
plot(abs(y1),'r');
title('fft(x) over n');

figure;
plot(freq, abs(y1),'r');
title('fft(x) over freq');

%fftshift
figure;
plot(abs(y2),'r');
title('fftshift(x) over n');

figure;
plot(freq, abs(y2),'r');
title('fftshift(x) over freq');
return ;


figure;
plot(abs(y2),'b');
title('fftshift over n');
return;

f=(0:2000)*Fs/n-Fs/2;

figure;
plot(f,abs(y1),'r'); %直接对fft结果作图，周期是200hz
title('fft @300hz');

figure;
plot(f,abs(y2),'b'); %周期改为100hz
title('fftshift @200hz');

figure;
plot(abs(y2),'b'); %周期改为100hz
title('fftshift x @200hz');
