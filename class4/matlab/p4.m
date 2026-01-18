t = -5:0.01:5;
dt = 0.01;
ft = heaviside(t+0.5) - heaviside(t-0.5);
% f(t/2)
ft2 = heaviside(t/2+0.5) - heaviside(t/2-0.5);
% f(2t)
ft3 = heaviside(2*t+0.5) - heaviside(2*t-0.5);

w = -10:0.01:10;
dw = 0.01;
% Fourier Transform
% ft
Fft = dt*ft*exp(-1j*t'*w);
Fft2 = dt*ft2*exp(-1j*t'*w);
Fft3 = dt*ft3*exp(-1j*t'*w);

figure;
subplot(2,2,1);
plot(t,ft);
title('Time Domain Signal f(t)');

subplot(2,2,2);
plot(w, abs(Fft));
title('Frequency Domain Signal |F(\omega)|');

subplot(2,2,3);
plot(w, abs(Fft2));
title('Frequency Domain Signal |F_{f(t-2)}(\omega)|');

subplot(2,2,4);
plot(w, abs(Fft3));
title('Frequency Domain Signal |F_{f(2t)}(\omega)|');

saveas(gcf, './p4_result.png');

