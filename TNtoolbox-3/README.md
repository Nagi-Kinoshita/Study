# TNtoolbox-3
## 使い方

適当な場所にこのリポジトリをクローンする。

```
git clone https://github.com/TokyoTechNagaiLab/TNtoolbox-3
```

ホームディレクトリ直下にクローンした場合、MATLAB上で `/home/ユーザー名/TNtoolbox-3` のようにパスを通す(サブフォルダーまでパスを通す必要はない)。

## 機能

### ディスプレイの測光

ColorCALIIを用いてガンマ特性を測定する場合は `tnt.calibration.GammaCurve` を実行する。

SpecBosを用いて分光分布を測定する場合は `tnt.calibration.Spectrum` を実行する。

### 色変換
4種の色変換クラスが存在する。詳細な説明は、MATLAB上で `doc tnt.RgbConverter` などとして確認できる。

#### RgbConverter

線形RGB色空間と各種色空間(CIE 1931 XYZ色空間、Judd修正XYZ色空間、LMS色空間)を変換できる。

#### DKLConverter

`RgbConverter` の変換に加えて、DKL色空間とLMS色空間の変換が出来る。

#### MbConverter

`DklConverter` の変換に加えて、MB色空間とLMS色空間の変換が出来る。

#### GammaConverter

線形RGB色空間からディスプレイ上のデジタルRGB色空間に変換できる。

### OpenEXR ファイルの読み込み
レンダリング結果の出力形式として一般的な、OpenEXR 形式のファイルをMatlab上に行列として読み込むことが出来る(`tnt.exr.read`)。
ただし、実行形式のバイナリファイル及びUbuntuの共有ライブラリに依存しているため、あらゆる環境での動作を保証できない。基本的にはOSがUbuntuで、CPUのアーキテクチャがx86の64bitであれば動作するはず。


## TNtoolbox-2との互換性
全ての色変換機能が TNtoolbox-2 と等しい結果になることを確認済みである(※1, ※2)。
以下の関数について、`test_vector = rand(3, 1000);` のようにして生成した、0~1の一様分布の乱数3000個を持つベクトルを色変換し、TNtoolbox-2 で変換した結果(`color2`)とTNtoolbox-3で変換した結果(`color3`)が全く同じ(`all(single(color2) == single(color3), 'all')` が true)になることを確認した。

※1 プログラムを高速化させるために記述を変更した影響により、倍精度浮動小数で比較すると等しくないが、単精度浮動小数に変換して比較すると等しくなっている。色変換の精度としては十分である。

※2 `DklConverter` の `dkl_scale_factor` と `MbConverter` の `mb_scale_factor` は逐次的に解を漸近させて求めているので、TNtoolbox-2 とは厳密に等しい値とはならないが、その差はTNtoolbox-2内で設定されている許容誤差 0.0000001 に収まっている。

### RgbConverter
 - function rgb = lms_to_linear_rgb(self, lms, option)
 - function lms = linear_rgb_to_lms(self, rgb, option)
 - function rgb = xyzj_to_linear_rgb(self, xyzj)
 - function xyzj = linear_rgb_to_xyzj(self, rgb)
 - function rgb = xyz_to_linear_rgb(self, xyz)
 - function xyz = linear_rgb_to_xyz(self, rgb)

### DklConverter
 - function lms = dkl_to_lms(self, dkl)
 - function dkl = lms_to_dkl(self, lms)
 - function rgb = lms_to_linear_rgb(self, lms)
 - function lms = linear_rgb_to_lms(self, rgb)

### MbConverter
 - function l_mb = lms_to_l_mb(self, lms)
 - function lms = l_mb_to_lms(self, l_mb)

### GammaConverter
 - function digital_rgb = linear_rgb_to_digital_rgb(self, linear_rgb, option)
 - function linear_rgb = digital_rgb_to_linear_rgb(self, digital_rgb, option)