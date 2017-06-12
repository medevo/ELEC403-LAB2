h0 = 0.07319351212;
h1 = 0.25;
h2 = 0.35361297576;

a = [1];
b = [h0 h1 h2 h1 h0];
[H,w] = freqz(b,a,1024);
figure;
plot(w,abs(H));
