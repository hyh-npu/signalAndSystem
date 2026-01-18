t = -2:0.01:2;
ft = (t+2).*(t<-1) + 1*(t<=1&t>=-1) + (-(t-2)).*(t>1);

%Fourier Transform
dt = 0.01;
dw = 0.01;
w = -10:0.01:10;
Fw = dt*ft*exp(-1j*t'*w);

figure;
subplot(3,1,1);
plot(t, ft);
title('Time Domain Signal f(t)');
subplot(3,1,2);
plot(w, abs(Fw));
title('Frequency Domain Signal |F(\omega)|');

%Inverse Fourier Transform
ft_reconstructed = (1/(2*pi))*dw*Fw*exp(1j*w'*t);
subplot(3,1,3);
plot(t, real(ft_reconstructed));
title('Reconstructed Time Domain Signal f(t) from F(\omega)');

saveas(gcf, './p3_result.png');
