delta = 0.01;
t = -5:delta:5;
f1 = (t-1).*(heaviside(t-1)-heaviside(t-3));
f2 = heaviside(t+2) - 2*heaviside(t-2);

c = conv(f1, f2) * delta;
ctime = -10:delta:10;

figure;
subplot(3,1,1);
plot(t, f1);
title('f1(t)');

subplot(3,1,2);
plot(t, f2);
title('f2(t)');

subplot(3,1,3);
plot(ctime, c);
title('f1(t) * f2(t)');

saveas(gcf, './p4.png');

