function [Y, Fs] = speed_change(y, fs, rate)
%  Y 输出信号，向量形式
%  Fs 输出采样率
%  y 输入信号，向量形式
%  fs 输入采样率
%  rate 变数比率， >1 加速

% 基本参数设置
    
    frameTime = 0.010; % 帧长 ms
    frameLength = frameTime * fs; % 帧长 点数
    overlapRate = 0.25; % 重叠率
    overlapLength = floor(frameLength * overlapRate); % 重叠点数
    frameNumber = floor((length(y)- frameLength) / (frameLength - overlapLength)) + 1; % 帧数
    outputOverlapRate =  (rate + overlapRate - 1) / rate; % 输出重叠率
    outputOverlapLength = floor(frameLength * outputOverlapRate); % 输出重叠点数
    
    % 分帧
    frames = zeros(frameNumber, frameLength);
    for i = 1:frameNumber
        frames(i, :) = y((i-1)*(frameLength - overlapLength) + 1 : (i-1)*(frameLength - overlapLength) + frameLength);
    end
    
    % 加窗
    window = hamming(frameLength)';
    windowedFrames = frames .* window;
    
    % 重叠相加
    Y = zeros(1, frameLength+ (frameNumber -1)*(frameLength - outputOverlapLength));
    for i = 1:frameNumber
        startIndex = (i-1)*(frameLength - outputOverlapLength) + 1;
        Y(startIndex : startIndex + frameLength -1) = Y(startIndex : startIndex + frameLength -1) + windowedFrames(i, :);
    end
    
    
    Fs = fs;
    
end
