clear; clc; close all;
%% 1. 读取音频（兼容立体声/单声道）
[audioIn, fs] = audioread('../name.wav');  
if size(audioIn, 2) > 1
    audioIn = mean(audioIn, 2);  % 转为单声道
end
% 检查原始音频是否有效
if max(abs(audioIn)) < 1e-6
    error('原始音频文件无信号，请检查name.wav是否存在且有效！');
end

%% 2. 核心调整参数（平衡"男声感"和"不憨+有声音"）
nsemitones = -9.5;           % 基频：-8（适度降频，保留声音）
preserve_formants = false;  % 保留共振峰（核心：避免闷/憨，且不丢声音）
gain = 0.9;                % 提高音量（避免声音小）
high_freq_boost = 1.05;     % 温和高频增强（不滤掉核心频段）

%% 3. 核心：调整基频（恢复合理窗长，避免信号丢失）
win_len = 1024;  % 恢复1024窗长（512太小易导致信号处理失真）
audioOut = shiftPitch(audioIn, nsemitones, ...
    'PreserveFormants', preserve_formants, ...
    'Window', hamming(win_len), ...
    'OverlapLength', round(win_len * 0.75), ...
    'LockPhase', true);

%% 4. 温和高频增强（替代硬高通，不丢声音）
% 问题根源：2kHz高通滤掉了人声核心频段→声音消失！
% 修正：用"低通+高频增益"，仅增强高频，不滤掉低频/中频
% 设计1000Hz~5000Hz的带通增强（人声清晰频段）
[b, a] = butter(2, [1000 5000]/(fs/2), 'bandpass'); % 2阶带通
audio_high = filtfilt(b, a, audioOut);              % 提取高频
audioOut = audioOut + (audio_high * (high_freq_boost - 1)); % 温和增强高频

%% 5. 音量归一化（避免失真+确保声音大小）
% 增加防除零：若信号全零，直接用原始音频（避免报错）
if max(abs(audioOut)) < 1e-6
    warning('处理后信号丢失，使用原始音频！');
    audioOut = audioIn;
end
audioOut = audioOut / max(abs(audioOut));  % 归一化到[-1,1]
audioOut = audioOut * gain;                % 提升音量

%% 6. 绘制频谱对比（验证信号存在）
figure('Color','w'); hold on; grid on;
plotSpectrum(audioIn, fs, '原始女声', 'b');
plotSpectrum(audioOut, fs, '调整后男声（有声音+不憨）', 'r');

title('音频频谱对比（修复声音消失问题）');
xlabel('频率 (Hz)'); ylabel('幅值');
xlim([0 3000]);  % 聚焦人声核心频段（0-3kHz）
ylim([0 0.03]);
legend('Location','best');
hold off;

%% 7. 保存+播放音频
audiowrite('to_male.wav', audioOut, fs);
disp('音频已保存为 to_male.wav');


%% 子函数：绘制单侧边频谱
function plotSpectrum(audio, fs, label, color)
    L = length(audio);
    ffta = fft(audio);
    P2 = abs(ffta/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    fp = fs*(0:(L/2))/L;
    plot(fp, P1, color, 'LineWidth', 1.2, 'DisplayName', label);
end
