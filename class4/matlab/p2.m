w = -10:0.01:10;
dw = 0.01;
Fw = -1j*2*w./(16+w.^2);

%inverse Fourier Transform
t = -5:0.01:5;
dt = 0.01;
ft = (1/(2*pi))*dw*Fw*exp(1j*w'*t);

figure;
subplot(2,1,1);
plot(w, abs(Fw));
title('Frequency Domain Signal |F(\omega)|');

subplot(2,1,2);
plot(t, real(ft));
title('Time Domain Signal f(t)');

saveas(gcf, './p2_result.png');

