clc; close all; clear;
audioPath = '../name.wav'
outputPath = './denoised_name.wav'
outputNoisedPath = './noised_name.wav'

% 噪声参数
noiseAmplitude = 0.02; % 噪声幅度
noiseFrequency = 1800; % 噪声频率 Hz

[y, fs] = audioread(audioPath);

original_fig = draw_spectrogram(y,fs);
saveas(original_fig, 'original_spectrogram.png')

% 添加噪声
noise = noiseAmplitude * sin(2 * pi * noiseFrequency * (0:length(y)-1)' / fs);
noisedSignal = y + noise;
audiowrite(outputNoisedPath, noisedSignal, fs);

% 绘制语谱图分析
% fig = draw_spectrogram(y, fs);
noised_fig = draw_spectrogram(noisedSignal, fs);
% saveas(fig, 'original_spectrogram.png');
saveas(noised_fig, 'noised_spectrogram.png');

% 降噪处理
[Y, Fs] = noise_suppress(noisedSignal, fs);
denoised_fig = draw_spectrogram(Y, Fs);
saveas(denoised_fig, 'denoised_spectrogram.png');
audiowrite(outputPath, Y, Fs);

figure;
stem(y, 'b', 'filled');
hold on;
stem( noisedSignal, 'r');
stem( Y, 'g');
hold off;
disp('Noise suppression processing completed.');

