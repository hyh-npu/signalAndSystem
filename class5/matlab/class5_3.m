Ts = 0.1;
t = -3:0.01:3;
T = -3:Ts:3;
ft = 2.*((t<0&t>-1)|(t>1&t<2))+1*(t>=0&t<=1);

%采样信号
fTs = 2.*((T<0&T>-1)|(T>1&T<2))+1*(T>=0&T<=1);

%数值傅里叶变换
dw = 0.01;
w = -100:dw:100;
FTw = dw.*fTs*exp(-1j*T'*w);

%抽样信号的还原

%低通滤波器
Hw = heaviside(w+pi/Ts)-heaviside(w-pi/Ts);
Ftw = FTw.*Hw;
%逆傅里叶变换
f_recon = (1/(2*pi)).*Ftw*exp(1j*w'*t)*dw;

figure;

subplot(4,1,1);
plot(t,ft);
title(' Original Signal f(t)');

subplot(4,1,2);
stem(T,fTs);
title(' Sampled Signal f_{Ts}(t)');

subplot(4,1,3);
plot(w,abs(FTw));
title('Magnitude Spectrum |F(w)|');

subplot(4,1,4);
plot(t,real(f_recon));
title(' Reconstructed Signal f_{recon}(t)');

saveas(gcf,'./class5_3.png');
