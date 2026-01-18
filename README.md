### 课程报告说明

## 报告说明

报告位于`./report.pdf`，内容包含八次实验课程报告。其中，第八次实验报告单独写为一章（大作业报告）。

报告中图表为浮动体，为了使内容更加紧凑，部分图表可能偏离对应位置。点击正文中的图片序号即可转到图表位置。

## 文件结构说明

为了不透露个人信息，部分文件做了删除或修改处理，但不影响正常使用。请参考下面的文件结构补充内容。

将你实验采集的图片或者数据放入对应位置覆盖原有图片（不改变命名），然后编译`./report.tex`即可得到报告。

将你采集到的音频放在`./homework/`的对应位置，运行所有可执行代码（也就是下面文件结构说明中的“运行代码”），即可得到图片（这部分图片代码自动保存到合适位置无需手动处理）。

下面为 `./homework/` 和 `./` 的文件结构说明

# `./homework/`

```
homework
├── filtered_results // 对原始音频进行带通滤波的结果，实际上实验使用的均为原始音频
│   ├── filtered_name.wav
│   └── filtered_number.wav
├── genderConverse // 女声变男声任务
│   ├── genderConversion.m // matlab 代码
│   ├── to_male.wav  // 输出男声音频
│   └── voiceContrast.png // 音频的频域对比
├── name.wav // 原始音频，女声，内容为组内成员姓名
├── noiseElimination // 添加噪声并滤波任务
│   ├── denoised_name.wav // 滤波后声音
│   ├── denoised_spectrogram.png // 滤波后语谱图
│   ├── draw_spectrogram.m // 绘图函数，用于绘制语谱图
│   ├── filter.png // 滤波器频域图像
│   ├── noised_name.wav // 添加噪声后的音频
│   ├── noised_spectrogram.png // 加入噪声后音频语谱图
│   ├── noise_suppress.m // 降噪函数
│   ├── original_spectrogram.png // 原始音频语谱图
│   └── runNoiseSuppress.m // 运行脚本
├── changeSpeed // 变速不变调任务
│   ├── fastname.wav // 原始音频加速结果
│   ├── runSpeedChange.m // 运行脚本
│   ├── slowname.wav  // 原始音频减速结果
│   └── speed_change.m  // 速度改变函数
├── countConverse  // 数字倒数代码
│   ├── numberConverse_visualization.png //可视化结果
│   ├── numberConverse.wav  //数字倒数音频
│   ├──  runCountConverse.m  // 数字倒数运行脚本
│   ├── directConverse.wav  // 直接倒放音频
│   └──  directConverse.m  // 直接倒放运行脚本
└── number.wav // 原始音频，男声，内容为数数字从0到10
```

# `./`

```
source
├── class1 // 实验1（其余class2~class7为同类型实验章节，结构一致）
│   ├── class1.tex // 实验1报告LaTeX源码
│   ├── class1.pdf // 实验1报告PDF
│   ├── matlab // 实验1信号处理、绘图相关MATLAB脚本与结果图
│   └── *.png/*.jpg // 实验1硬件实验图，以及报告中说明用插图
├── class2 // 实验2
├── class3 // 实验3
├── class4 // 实验4
├── class5 // 实验5
├── class6 // 实验6
├── class7 // 实验7
├── homework // 大作业（具体内容见独立homework目录）
├── logo.png // 实验报告封面logo图片
├── report.tex // 总实验报告LaTeX源码
├── report.pdf // 最终生成的总实验报告PDF
└── report.toc // 总报告目录文件
(其余未说明文件类型为临时文件)

```

## 代码运行说明

文件中包含的代码，除 `./sourec/class1` 以及 `./homework/genderConverse/`中代码在 `MATLAB online` 运行得到结果以外，其余代码运行的MATLAB版本是：`R2024b Update 1 (24.2.0.2740171) 64-bit (glnxa64)`

## Tex配置说明

文件中使用的Tex参考配置如下：

```

main parser: texroot specifier
  document class: ctexbook
  document class options: a4paper=true oneside=true
  packages: CJKfntef amsbsy amsgen amsmath amsopn amstext bigintcalc bitset booktabs caption caption3 color ctexhook ctexpatch etoolbox expl3 fancyhdr fix-cm float fontenc fontspec fontspec-xetex geometry gettitlestring graphics graphicx hycolor hyperref iftex ifvtex import infwarerr intcalc keyval kvdefinekeys kvoptions kvsetkeys listings lstlang1 lstmisc lstpatch ltxcmds multirow nameref pdfescape pdftexcmds refcount rerunfilecheck setspace stringenc subcaption subfiles textpos trig uniquecounter url xcolor xeCJK xeCJK-listings xeCJKfntef xparse xtemplate zhnumber
  source files:
    report.tex
    class1/class1.tex
    class2/class2.tex
    class3/class3.tex
    class4/class4.tex
    class5/class5.tex
    class6/class6.tex
    class7/class7.tex
    homework/homework.tex
  compiler: latexmk
    engine: -pdf
    options:
      -pdflatex=xelatex
      -pdf
      -shell-escape
      -synctex=1
      -interaction=nonstopmode
      -file-line-error
    callback: 1
    continuous: 1
    executable: latexmk
```

```
