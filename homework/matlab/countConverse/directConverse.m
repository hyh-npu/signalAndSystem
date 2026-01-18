
input_path = '../number.wav';   % 原始音频文件
output_path = 'directConverse.wav'; % 倒放后保存路径

[y, Fs] = audioread(input_path);

y_rev = flipud(y);

audiowrite(output_path, y_rev, Fs);

fprintf('保存至：%s\n', output_path);
