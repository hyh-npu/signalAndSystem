t= sym('t');

ft = 2* exp(j*(t+ pi/4));

realf = real(ft);
imagf = imag(ft);
absf = abs(ft);
angf = angle(ft);

figure;

subplot(2,2,1);
fplot(t, realf);
title('Real Part of f(t)');

subplot(2,2,2);
fplot(t, imagf);
title('Imaginary Part of f(t)');

subplot(2,2,3);
fplot(t, absf);
title('Magnitude of f(t)');

subplot(2,2,4);
fplot(t, angf);
title('Phase of f(t)');

saveas(gcf, './p3.png');
