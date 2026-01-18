
function [Y, Fs] = noise_suppress(y, fs)
% 降噪函数：修复信号长度/维度/幅值异常问题
% 输入：y-输入信号（向量），fs-采样率
% 输出：Y-输出信号（列向量，长度与输入完全一致），Fs-采样率


    if ~isvector(y)
        error('输入y必须是向量！当前是矩阵，维度：%s', mat2str(size(y)));
    end
    y = y(:); 
    sig_len = length(y); 
    Fs = fs; 
    
    frameTime = 0.010; % 帧长 10ms
    frameLength = round(frameTime * fs); % 帧长（点数）
    if frameLength >= sig_len 
        frameLength = max(floor(sig_len/2), 2); 
    end
    overlapRate = 0.75; % 重叠率
    overlapLength = floor(frameLength * overlapRate); % 重叠点数
    frameStep = frameLength - overlapLength; % 帧移
     
    frameNumber = ceil((sig_len - frameLength) / frameStep) + 1; 

    
    frames = zeros(frameNumber, frameLength); % 帧矩阵：帧数×帧长
    for i = 1:frameNumber
        start_idx = (i-1)*frameStep + 1;
        end_idx = start_idx + frameLength - 1;
        
        if end_idx > sig_len
            frame_data = zeros(1, frameLength);
            valid_len = sig_len - start_idx + 1;
            frame_data(1:valid_len) = y(start_idx:end);
            frames(i, :) = frame_data;
        else
            frames(i, :) = y(start_idx:end_idx)'; 
        end
    end

    
    window = hamming(frameLength); 
    windowedFrames = frames .* window'; 

    noiseFreq = 1800; % 噪声中心频率
    eliminationRate = 300; % 带阻宽度
    denoisedFrames = zeros(size(windowedFrames)); % 降噪帧矩阵
    
    freq = (0:frameLength-1) * (fs / frameLength); 

    for i = 1:frameNumber
       
        frameFFT = fft(windowedFrames(i, :)); 
        magnitude = abs(frameFFT); % 幅值
        phase = angle(frameFFT);   % 相位
        
        freqDist = abs(freq - noiseFreq); 
        freqDist = min(freqDist, abs(fs - freq - noiseFreq)); 
        bandElimination = 1 - exp( -freqDist.^2 / (2 * eliminationRate^2) );
        % 频域降噪
        denoisedFrameFFT = magnitude .* bandElimination .* exp(1j * phase);
         
        denoisedFrame = real(ifft(denoisedFrameFFT)); 
        denoisedFrames(i, :) = denoisedFrame;
    end

    
    compensationWindow = hamming(frameLength); % 补偿窗
    
    denoisedFrames = denoisedFrames ./ (compensationWindow' + eps) * 0.5; 
    denoisedFrames(isnan(denoisedFrames) | isinf(denoisedFrames)) = 0; 

    
    Y = zeros(sig_len, 1); 
    weight = zeros(sig_len, 1); 
    for i = 1:frameNumber
        start_idx = (i-1)*frameStep + 1;
        end_idx = start_idx + frameLength - 1;
        
        if end_idx > sig_len
            end_idx = sig_len;
            valid_len = end_idx - start_idx + 1;
            Y(start_idx:end_idx) = Y(start_idx:end_idx) + denoisedFrames(i, 1:valid_len)';
            weight(start_idx:end_idx) = weight(start_idx:end_idx) + window(1:valid_len);
        else
            Y(start_idx:end_idx) = Y(start_idx:end_idx) + denoisedFrames(i, :)';
            weight(start_idx:end_idx) = weight(start_idx:end_idx) + window;
        end
    end
    Y(weight > 0) = Y(weight > 0) ./ weight(weight > 0);
    Y(weight == 0) = 0; 

    figure('Name', '1800Hz高斯陷波滤波器');
    plot(freq, bandElimination, 'LineWidth', 1.2);
    xlabel('频率 (Hz)'); ylabel('增益');
    title(sprintf('高斯陷波滤波器（中心频率：%d Hz）', noiseFreq));
    xlim([1000, 2500]); grid on; box on;
    saveas(gcf, './filter.png');
    close(gcf); 

end

