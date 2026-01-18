Ts = 0.3; %采样周期
ts = -4:Ts:4;
t = -4:0.01:4;
%原始信号和采样信号

fs = 1/2.*(1.+cos(ts)).*(heaviside(ts+2*pi)-heaviside(ts-2*pi));
f = 1/2.*(1.+cos(t)).*(heaviside(t+2*pi)-heaviside(t-2*pi));
figure;
subplot(2,2,1);
plot(t,f);
title(' Original Signal f(t)');
subplot(2,2,2);

stem(ts,fs);
title(' Sampled Signal fs(t)');

%信号恢复
wc = pi/Ts;         
sinc_mat = sinc( wc/pi * (t'*ones(1,length(ts)) - ones(length(t),1)*ts) );
fr = sum( fs .* sinc_mat, 2 ); 
subplot(2,2,3);
plot(t,fr);
title(' Reconstructed Signal fr(t)');

bias = fr - f';
subplot(2,2,4);
plot(t,bias);
title(' Reconstruction Error fr(t)-f(t)');





%保存图片
handle = gcf;
saveas(handle,'class5_2.png');
