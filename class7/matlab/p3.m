t_length = 10;
N = 64;

T = t_length/N;
t = (0:N-1)*T - t_length/2;

x = heaviside(t+0.5) - heaviside(t-0.5);
w_length = 2*pi/T;
W = w_length/N;
w = (0:N-1)*W;
disp('f(t) Computing FFT...');
tic
X = T*fft(x,N);
X = fftshift(X);
toc

x_num = x;
w_num = linspace(-w_length/2, w_length/2, N);
disp('Computing Numerical FT...');
tic
W_num = x_num .* exp(-1j * w_num' * t);
toc

figure;
subplot(3,2,1);
stem(t,x);
title('Signal x(t)');

subplot(3,2,2);
stem(w-w_length/2,abs(X));
hold on;
plot(w_num, abs(sum(W_num,2))*T, 'r');
title('Magnitude Spectrum of x(t)');
hold off;

x = heaviside(t/2+0.5) - heaviside(t/2-0.5);
w_length = 2*pi/T;
W = w_length/N;
w = (0:N-1)*W;
disp('f(t/2) Computing FFT...');
tic
X = T*fft(x,N);
X = fftshift(X);
toc

x_num = x;
w_num = linspace(-w_length/2, w_length/2, N);
disp('Computing Numerical FT...');
tic
W_num = x_num .* exp(-1j * w_num' * t);
toc

subplot(3,2,3);
stem(t,x);
title('Signal x(t)');

subplot(3,2,4);
stem(w-w_length/2,abs(X));
hold on;
plot(w_num, abs(sum(W_num,2))*T, 'r');
title('Magnitude Spectrum of x(t)');
hold off;


x = heaviside(2.*t+0.5) - heaviside(2.*t-0.5);
w_length = 2*pi/T;
W = w_length/N;
w = (0:N-1)*W;
disp('f(2t) Computing FFT...');
tic
X = T*fft(x,N);
X = fftshift(X);
toc

x_num = x;
w_num = linspace(-w_length/2, w_length/2, N);
disp('Computing Numerical FT...');
tic
W_num = x_num .* exp(-1j * w_num' * t);
toc

subplot(3,2,5);
stem(t,x);
title('Signal x(t)');

subplot(3,2,6);
stem(w-w_length/2,abs(X));
hold on;
plot(w_num, abs(sum(W_num,2))*T, 'r');
title('Magnitude Spectrum of x(t)');
hold off;


saveas(gcf, './p3.png');
