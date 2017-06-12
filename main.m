close;

h0 = 0.07319351212;
h1 = 0.25;
h2 = 0.35361297576;

a = [1];
b = [h0 h1 h2 h1 h0];
[H,w] = freqz(b,a,1024);
%figure;
%plot(w,abs(H));

clear;
h0 = 0.07319351212;
h1 = 0.25;
h2 = 0.35361297576;

t = 0:1/512:(2-1/512);
t = t(:);
randn('state', 7)
a = 0.2*randn(7,1);
randn('state', 19)
b = 0.2*randn(7,1);
s = 0.3*ones(1024,1);
for i = 1:7,
 s1 = a(i)*sin(2*pi*i*t);
 s2 = b(i)*cos(2*pi*(i-0.5)*t);
 s = s + s1 + s2;
end 

randn('state',9); % sets a seed state for generating a random sequence
w0 = randn(1024,1); % generate 1024 Gaussian white random samples
mw = mean(w0); % evaluate its mean value
w0 = w0 - mw; % modify w0 to have a zero-mean
c = 0.3/sqrt((w0'*w0)/1024);
w0 = c*w0; % modify w0 to have a standard deviation = 0.3
h = fir1(250,0.7,'high'); % get a good highpass FIR filter with cutoff freq. = 0.7
w1 = conv(h,w0); % apply highpass filtering to the white noise sequence
w = w1(126:1149); % cut the filtered sequence to a right size
w = w(:); % make sure w[n] is a column vector 

x = s + w; 

%Fourier plot of x
subplot(2,3,1);
xf = fft(x); % perform FFT of signal x[n]
xf = fftshift(xf); % shift zero-frequency component to center of spectrum
f = -256:512/1023:256; % define an appropriate frequency axis for plotting
plot(f,abs(xf))
axis([-256 256 0 350])
grid
xlabel('Frequency in Hz')
title('Spectrum of received signal x[n]') 

%Fourier plot of s
subplot(2,3,2);
sf = fft(s); % perform FFT of signal x[n]
sf = fftshift(sf); % shift zero-frequency component to center of spectrum
f = -256:512/1023:256; % define an appropriate frequency axis for plotting
plot(f,abs(sf))
axis([-256 256 0 350])
grid
xlabel('Frequency in Hz')
title('Spectrum of received signal s[n]') 

%Fourier plot of w
subplot(2,3,3);
wf = fft(w); % perform FFT of signal x[n]
wf = fftshift(wf); % shift zero-frequency component to center of spectrum
f = -256:512/1023:256; % define an appropriate frequency axis for plotting
plot(f,abs(wf))
axis([-256 256 0 350])
grid
xlabel('Frequency in Hz')
title('Spectrum of received signal w[n]') 

subplot(2,3,4);
plot(s);
xlabel('Samples')
title('Signal S') 

subplot(2,3,5);
plot(x)
xlabel('Samples')
title('Signal X') 

tapFilter = [h0 h1 h2 h1 h0];
y_raw = conv(x,tapFilter);
y_opt = y_raw(3:1026);

subplot(2,3,6);
plot(y_opt,'-b');
hold on
plot(s,'-r')
legend('Y','S')
xlabel('Samples')
title('Signal Y versus signal X')

errorAfter = 20*log(norm(s)/norm(y_opt-s))
errorBefore = 20*log(norm(s)/norm(x-s))

filterOne   = fir1(4,0.1);
filterTwo   = fir1(4,0.3);
filterThree = fir1(4,0.6);
y_raw1 = conv(x,filterOne);
y_raw2 = conv(x,filterTwo);
y_raw3 = conv(x,filterThree);
y_opt1 = y_raw1(3:1026);
y_opt2 = y_raw2(3:1026);
y_opt3 = y_raw3(3:1026);

figure;
subplot(1,3,1);
hold on;
plot(y_opt1,'-b');
plot(s,'-r')
xlabel('Samples')
title('Filter Cutoff w = 0.1') 

subplot(1,3,2);
hold on;
plot(y_opt2,'-b');
plot(s,'-r')
xlabel('Samples')
title('Filter Cutoff w = 0.3') 

subplot(1,3,3);
hold on;
plot(y_opt3,'-b');
plot(s,'-r')
xlabel('Samples')
title('Filter Cutoff w = 0.6') 

snrfilter1After = 20*log(norm(s)/norm(y_opt1-s))
snrfilter2After = 20*log(norm(s)/norm(y_opt2-s))
snrfilter3After = 20*log(norm(s)/norm(y_opt3-s))









