%0.2*dy/dt + y = x
%系统传递函数H(jw) = Y(jw)/X(jw) = 1/(0.2jw+1)
%x(t) = u(t) - u(t-1)
t = -5:0.01:5;
sys = tf([0,0,1],[0,0.2,1]);
xt = heaviside(t) - heaviside(t-1);

figure;
%频域分析 数值法
dt = 0.01;
w = -10:0.01:10;
dw = 0.01;
Xw = dt*xt*exp(-1j*t'*w);
Hw = freqs([0,0,1],[0,0.2,1],w);
Yw = Hw.*Xw;
yt = (1/(2*pi))*dw*Yw*exp(1j*w'*t);
%time domain output
subplot(2,1,1);
plot(t, abs(yt));
title('Time Domain Signal y(t) from Frequency Domain Analysis');

%时域分析
yt2 = lsim(sys, xt, t);
subplot(2,1,2);
plot(t, yt2);
title('Time Domain Signal y(t) from Time Domain Analysis');

saveas(gcf, './p6_result.png');
