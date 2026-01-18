sys = tf([0,3,2],[1,5,6]);
t = -3:0.01:10;
yd = impulse(sys,t);
yu = step(sys,t);

figure;
subplot(3,1,1);
plot(t,yd);
title('Impulse Response');

subplot(3,1,2);
plot(t,yu);
title('Step Response');


f= exp(-2.*t).*heaviside(t);
yf = lsim(sys,f,t);

subplot(3,1,3);
plot(t,yf);
title('Response to f(t) = e^{-2t}u(t)');


saveas(gcf,'./p1.png');

