b = [0,1j,0];
a = [-1,1j,100];
w = -10:0.01:10;
res = freqs(b,a,w);

figure;
subplot(2,1,1);
plot(w, abs(res));
title('Frequency Domain Signal |F(\omega)|');

subplot(2,1,2);
plot(w, angle(res));
title('Frequency Domain Signal Phase \angleF(\omega)');

saveas(gcf, './p5_result.png');


