
dt = 0.01;
t = -5:0.01:5;
ft = sin(2.*pi.*(t-1))./(pi.*(t-1));
ft(isnan(ft)) = 2;  % 替换t=1处的NaN为极限值2

domega = 0.01;
omega = -10:domega:10;
Fft = dt*ft*exp(-1j*t'*omega);


figure;
subplot(2,1,1);
plot(t, ft);
title('Time Domain Signal f(t)');

subplot(2,1,2);
plot(omega, abs(Fft));
title('Frequency Domain Signal |F(\omega)|');

saveas(gcf, './p1_result.png');

