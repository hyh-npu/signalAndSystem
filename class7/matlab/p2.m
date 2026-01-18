t_length = 20;
N = 64;

T = t_length/N;
t = (0:N-1)*T - t_length/2;

x = (t + 2).*(t>=-2&t<-1)+1.*(t>=-1&t<=1)+(2 - t).*(t>1&t<=2);

w_length = 2*pi/T;
W = w_length/N;
w = (0:N-1)*W;
disp('Computing FFT...');
tic
X = T*fft(x,N);
X = fftshift(X);
toc
time_of_fft = toc - tic;

x_num = x;
w_num = linspace(-w_length/2, w_length/2, N);
disp('Computing Numerical FT...');
tic
W_num = x_num .* exp(-1j * w_num' * t);
toc
toc_of_num = toc - tic;
figure;
subplot(2,1,1);
stem(t,x);
title('Signal x(t)');

subplot(2,1,2);
stem(w-w_length/2,abs(X));
hold on;
plot(w_num, abs(sum(W_num,2))*T, 'r');
title('Magnitude Spectrum of x(t)');
hold off;

saveas(gcf, './p2.png');
