
function fig = draw_spectrogram(signal, fs, save_path)

    if ~isa(signal, 'double')
        signal = double(signal);
    end
    if ismatrix(signal)
        signal = signal(:, 1);
    end
    signal = signal(:); 

    % 语谱图参数
    window_size = 256; 
    overlap = 128;     
    nfft = 512;        

    
    [S, F, T] = spectrogram(signal, window_size, overlap, nfft, fs);
    S_abs = abs(S);
    S_abs(S_abs == 0) = eps;  
    S_dB = 10*log10(S_abs);

    
    fig_width = 1200;    
    fig_height = 800;    
    fig = figure(...
        'Name', 'Spectrogram', ...
        'Position', [100, 100, fig_width, fig_height], ... % [左偏移, 下偏移, 宽, 高]
        'Units', 'inches', ...  
        'Color', 'white' ... 
    );

      ax = axes(...
        'Parent', fig, ...
        'Position', [0.08, 0.1, 0.75, 0.8], ... % [左, 下, 宽, 高]
        'Units', 'normalized' ...
    );
    imagesc(ax, T, F, S_dB); 
    axis(ax, 'xy');  
    xlabel(ax, 'Time (s)', 'FontSize', 12); 
    ylabel(ax, 'Frequency (Hz)', 'FontSize', 12);
    title(ax, 'Spectrogram', 'FontSize', 14);
    set(ax, 'FontSize', 10); %

    
    cb = colorbar(ax, 'Position', [0.87, 0.1, 0.03, 0.8]); 
    cb.Label.String = 'Amplitude (dB)';
    cb.Label.FontSize = 11;
    set(cb, 'FontSize', 10);

    
    caxis(ax, [-80 20]); 

        if nargin >= 3 && ~isempty(save_path)
        
        print(fig, save_path, '-dpng', '-r600', '-painters');
        fprintf('语谱图已保存至：%s（600dpi，尺寸：%d×%d英寸）\n', save_path, fig_width, fig_height);
    end
end

