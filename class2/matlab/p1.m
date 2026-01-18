t = sym('t');

ut = heaviside(t);

f1 = (2 - exp(-2*t)) .* ut;

f2 = cos(pi * t /2)* (heaviside(t) - heaviside(t-4));

f3 = exp(t)* cos(t)* ut;

f4 = 2/3 *t *heaviside(t +2);

figure;

subplot(2,2,1);
fplot(f1);
title("signal 1");

subplot(2,2,2);
fplot(f2);
title("signal 2");

subplot(2,2,3);
fplot(f3);
title("signal 3");

subplot(2,2,4);
fplot(f4);
title("signal 4");

saveas(gcf, './p1_signals.png');
