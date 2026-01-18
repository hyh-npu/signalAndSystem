sys = tf([0,0,4],[0,1,12]);
t = -3:0.01:10;

yd = impulse(sys,t);
yu = step(sys,t);

f = 12 .* heaviside(t);

yf = lsim(sys,f,t);

figure;
subplot(3,1,1);
plot(t,yd);
title('Impulse Response');

subplot(3,1,2);
plot(t,yu);
title('Step Response');

subplot(3,1,3);
plot(t,yf);
title('Response to f(t) = 12u(t)');

saveas(gcf,'./p2.png');
