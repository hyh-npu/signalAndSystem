delta = 0.01;
t = -5:delta:5;
f1 = heaviside(t+1) - heaviside(t-1);
f2 = (t + 3).*(t>-3&t<-2) + 1.*(t>=-2&t<=0) + (1-t).*(t>0&t<1);

c = conv(f1, f2) * delta;
ctime = -10:delta:10;

figure;
subplot(3,1,1);
plot(t, f1);
title('f1(t)');

subplot(3,1,2);
plot(t, f2);
title('f2(t)');
title('f2(t)');

subplot(3,1,3);
plot(ctime, c);
title('f1(t) * f2(t)');

saveas(gcf, './p3.png');
