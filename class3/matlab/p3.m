sys = tf([0,1,0],[1,1,100]);

t = -3:0.01:10;

yd = impulse(sys,t);
yu = step(sys,t);

figure;
subplot(2,1,1);
plot(t,yd);
title('Impulse Response');

subplot(2,1,2);
plot(t,yu);
title('Step Response');

saveas(gcf,'./p3.png');
