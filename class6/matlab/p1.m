delta = 0.01;
t = -10:delta:10;
f1 = heaviside(t) - heaviside(t-2);
f2 =  heaviside(t+3) - heaviside(t);

c12 = conv(f1, f2) * delta;
c11 = conv(f1, f1) * delta;
c22 = conv(f2, f2) * delta;
ctime = -20:delta:20;

figure;
subplot(2,3,1);
plot(t, f1);
title('f1(t)');

subplot(2,3,2);
plot(t, f2);
title('f2(t)');

subplot(2,3,4);
plot(ctime, c11);
title('f1(t) * f1(t)');

subplot(2,3,5);
plot(ctime, c12);
title('f1(t) * f2(t)');

subplot(2,3,6);
plot(ctime, c22);
title('f2(t) * f2(t)');

saveas(gcf, './p1.png');


