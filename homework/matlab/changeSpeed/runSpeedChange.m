% 基本信息
audiopath =  '../name.wav'; 
outputpathFast = './fastname.wav'
outputpathSlow = './slowname.wav'

[y,Fs] = audioread(audiopath); 
[Yf, Fsf] = speed_change(y, Fs, 2); 
audiowrite(outputpathFast, Yf, Fsf); 

[Ys, Fss] = speed_change(y, Fs, 0.5);
audiowrite(outputpathSlow, Ys, Fss);

%输出基本信息
disp('Speed change processing completed.');

