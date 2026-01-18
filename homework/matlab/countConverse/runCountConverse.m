clear; clc; close all;

%% 基础参数
cfg = struct();
cfg.audio_path     = '../number.wav';       % 输入音频文件
cfg.shift_time     = 0.25;              % 段起始前移时间（秒）
cfg.energy_thresh  = 0.05;              % 能量阈值，控制语音段识别
cfg.win_size_ms    = 20;                % 滑动窗口时长（毫秒）
cfg.min_seg_len_ms = 100;               % 最小语音段长度（毫秒）
cfg.target_seg_num = 10;                % 目标分割段数

[audioIn, fs] = audioread(cfg.audio_path);
audioIn = mean(audioIn, 2);            
audioIn = audioIn / max(abs(audioIn)); 
total_samples = length(audioIn);
total_duration = total_samples / fs;

fprintf(' 音频信息：\n');
fprintf(' 采样率：%d Hz | 总时长：%.2f 秒 | 总样本数：%d\n', fs, total_duration, total_samples);
fprintf('_______________________________________________________________\n');

win_size = round(fs * cfg.win_size_ms / 1000);  
half_win = floor(win_size / 2);
audio_energy = zeros(total_samples, 1);         

for i = 1:total_samples
    start_idx = max(1, i - half_win);
    end_idx   = min(total_samples, i + half_win);
    window_audio = audioIn(start_idx:end_idx);
    audio_energy(i) = sqrt(mean(window_audio.^2));
end

%%  语音段自动分割
min_seg_len = round(fs * cfg.min_seg_len_ms / 1000); 
segments = [];          % 语音段存储矩阵
start_idx = 0;          % 语音段起始标记

for i = 1:total_samples
    if audio_energy(i) > cfg.energy_thresh && start_idx == 0
        start_idx = i;
    elseif audio_energy(i) <= cfg.energy_thresh && start_idx ~= 0
        end_idx = i;
        if (end_idx - start_idx) > min_seg_len
            segments = [segments; start_idx, end_idx];
        end
        start_idx = 0;
    end
end
if start_idx ~= 0 && (total_samples - start_idx) > min_seg_len
    segments = [segments; start_idx, total_samples];
end

% 微调阈值以匹配目标段数
num_seg = size(segments, 1);
max_adjust_times = 3;  % 最大微调次数
adjust_count = 0;

while num_seg ~= cfg.target_seg_num && adjust_count < max_adjust_times
    adjust_count = adjust_count + 1;
    if num_seg < cfg.target_seg_num
        cfg.energy_thresh = cfg.energy_thresh * 0.9;
        fprintf(' 第%d次微调：段数不足（%d段），能量阈值降至%.3f\n', adjust_count, num_seg, cfg.energy_thresh);
    else
        cfg.energy_thresh = cfg.energy_thresh * 1.1;
        fprintf(' 第%d次微调：段数过多（%d段），能量阈值升至%.3f\n', adjust_count, num_seg, cfg.energy_thresh);
    end
    
    segments = []; start_idx = 0;
    for i = 1:total_samples
        if audio_energy(i) > cfg.energy_thresh && start_idx == 0, start_idx = i; end
        if audio_energy(i) <= cfg.energy_thresh && start_idx ~= 0
            if (i - start_idx) > min_seg_len, segments = [segments; start_idx, i]; end
            start_idx = 0;
        end
    end
    if start_idx ~= 0 && (total_samples - start_idx) > min_seg_len
        segments = [segments; start_idx, total_samples];
    end
    num_seg = size(segments, 1);
end

% 最终段数检查
if num_seg ~= cfg.target_seg_num
    if num_seg < cfg.target_seg_num
        tip = '调小energy_thresh（如0.04）';
    else
        tip = '调大energy_thresh（如0.06）';
    end
    warning(' 最终分割出%d段（目标%d段）→ %s', num_seg, cfg.target_seg_num, tip);
else
    fprintf(' 成功分割出%d段语音（匹配1~10）\n', cfg.target_seg_num);
end

%%  语音段起始前移
shift_samples = round(fs * cfg.shift_time);  
segments_adjusted = segments;
for i = 1:num_seg
    segments_adjusted(i, 1) = max(1, segments_adjusted(i, 1) - shift_samples);
end

%%  提取原音频所有间隔
intervals_all = [];
for i = 1:num_seg-1
    interval_between = segments_adjusted(i+1, 1) - segments_adjusted(i, 2);
    intervals_all = [intervals_all; interval_between];
end
interval_after_last = total_samples - segments_adjusted(end, 2);
intervals_all = [intervals_all; interval_after_last];

%%  拼接音频 
reversed_segments = flipud(segments_adjusted);
reversed_intervals = flipud(intervals_all);

audioOut = [];
for i = 1:num_seg
    seg_audio = audioIn(reversed_segments(i, 1):reversed_segments(i, 2));
    audioOut = [audioOut; seg_audio];
    silence = zeros(reversed_intervals(i), 1);
    audioOut = [audioOut; silence];
end

audioOut = audioOut / max(abs(audioOut)) * 0.9;

%%  保存最终音频 
output_path = 'numberConverse.wav';
audiowrite(output_path, audioOut, fs);
fprintf('音频已保存：%s\n', output_path);

%% 可视化绘图
figure('Color','w','Position',[100 100 1000 700],'Name','音频反转结果可视化');

% 原始音频
subplot(2,1,1);
t_raw = (0:total_samples-1)/fs;
plot(t_raw, audioIn, 'Color', [0.2 0.4 0.6], 'LineWidth', 1); hold on;
% 标记原始段和前移后的段
for i = 1:num_seg
    plot([segments(i,1)/fs, segments(i,1)/fs], ylim, 'Color', [0.8 0.2 0.2], 'LineStyle', '--', 'LineWidth', 1);
    plot([segments_adjusted(i,1)/fs, segments_adjusted(i,1)/fs], ylim, 'Color', [0.2 0.8 0.2], 'LineStyle', '-', 'LineWidth', 1.5);
    text(segments_adjusted(i,1)/fs, 0.8, num2str(i), 'Color', [0.2 0.8 0.2], 'FontSize', 9, 'FontWeight', 'bold');
end
title('原始音频', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('时间（秒）', 'FontSize', 10); ylabel('幅值', 'FontSize', 10);
xlim([0, total_duration]); ylim([-1.1, 1.1]);
grid on; 
ax1 = gca;
ax1.LineWidth = 0.5;  
box on;
legend('原始音频','原段起始','前移后段起始','Location','best','FontSize',9);

% 反转音频
subplot(2,1,2);
t_rev = (0:length(audioOut)-1)/fs;
plot(t_rev, audioOut, 'Color', [0.8 0.4 0.2], 'LineWidth', 1); hold on;
rev_seg_times = [];
current_pos = 1;
for i = 1:num_seg
    seg_len = reversed_segments(i,2) - reversed_segments(i,1) + 1;
    seg_start = (current_pos - 1)/fs;
    seg_end = (current_pos + seg_len - 1)/fs;
    rev_seg_times = [rev_seg_times; seg_start, seg_end];
    plot([seg_start, seg_start], ylim, 'Color', [0.2 0.4 0.6], 'LineStyle', '--', 'LineWidth', 1);
    text((seg_start+seg_end)/2, 0.8, num2str(11-i), 'Color', [0.2 0.4 0.6], 'FontSize', 9, 'FontWeight', 'bold');
    current_pos = current_pos + seg_len + reversed_intervals(i);
end
title('反转后音频', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('时间（秒）', 'FontSize', 10); ylabel('幅值', 'FontSize', 10);
xlim([0, t_rev(end)]); ylim([-1.1, 1.1]);
grid on;  
ax2 = gca;
ax2.LineWidth = 0.5; 
box on;

set(gcf, 'DefaultAxesFontName', 'SimHei');
set(gcf, 'DefaultTextFontName', 'SimHei');

saveas(gcf, 'numberConverse_visualization.png');
