using Pkg
Pkg.activate(@__DIR__) # このファイルがあるフォルダの環境を有効化
using Plots, StatsPlots # 可視化パッケージ
gr()    # バックエンドの指定
using Statistics    # 統計関数を使用するために必要（mean(), var(), cov()など）
using LinearAlgebra # 線形代数パッケージ（inv(), logdet()など）

# ---1. 学習データの読み込み---
# pima.tr.csvのファイルパスを設定する
filepath = joinpath(@__DIR__, "Pima.tr.csv")

# pima.tr.csv（filepath）を読み出す
lines = open(filepath, "r") do io
    #readlines(io)  # 普通に読み込む場合
    # タイトル行を削除する
    # |> : パイプライン
    # collect : 値やキーを配列にする関数
    Iterators.drop(eachline(io), 1) |> collect
end

# # 【テスト】読み出した行の確認
# for i in 1:6    # `i = 1:6`や`i ∈ 1:6`でも等価だがinが多い
#     println(lines[i])
# end

# データ配列の準備
glu_tr = Int64[]
bmi_tr = Float64[]
type_tr = Bool[]

# 読み出した行をカンマ区切りのデータ配列にする
for line in lines
    # Pima.tr.csvの順番でデータを変数に変換
    # 変数名はタイトル行のママ
    # strip : 両端の空白を削除（今回は不要）
    #rownames, npreg, glu, bp, skin, bmi, ped, age, type = split(strip(line), ",")  # 今回の場合はstrip
    rownames, npreg, glu, bp, skin, bmi, ped, age, type = split(line, ",")

    # 配列に挿入
    # push! : 順番に追加
    # rownamesをインデックスにする方法もあるが冗長なコードになる
    push!(glu_tr,  parse(Int64, glu))
    push!(bmi_tr,  parse(Float64, bmi))
    push!(type_tr, strip(type)=="Yes")  # Yesの時に真を設定
end

# # 【テスト】変数の確認
# for i in 1:5
# #     println("glu=", glu_tr[i], " / bmi=", bmi_tr[i])
#     if type_tr[i]
#         println("glu=", glu_tr[i], " / bmi=", bmi_tr[i])
#     end
# end


# ---2. 学習データのプロット---
# # 【テスト】データのプロット
# # scatter : 散布図のプロット

# # (A)st=:scatterで散布図を指定
# # VSCodeがst=:scatter使用に関してエラーを返してくるが正常に動作する（基本は折れ線グラフ）
# plot(glu_tr, bmi_tr, 
# xlabel="glu",
# ylabel="bmi",
# label=false,    # 凡例を表示しない
# title="Pima indian Diagnosis of Diabetes",
# size=(600,600), # 描画サイズを指定
# aspect_ratio=:auto, # アスペクト比を自動（auto）に指定
# st=:scatter)   # =:の後に半角スペースを入れるとエラー

# #(B)scatter()を使用
# scatter(glu_tr, bmi_tr, 
# xlabel="glu",
# ylabel="bmi",
# label=false,    # 凡例を表示しない
# title="Pima indian Diagnosis of Diabetes",
# size=(600,600), # 描画サイズを指定
# aspect_ratio=:auto # アスペクト比を自動（auto）に指定
# )

#=
図4.8
学習データの散布図（発症の有無別にプロット）
=#

# 発症の有無によりプロットするマークを区別する
# plotやscatterは準備されているデータを扱うので内部でifは使えない
# Juliaはcolorやmarkerを配列で指定できる


# ---(1) データと同じ長さの色とマークの配列を準備---
# type_tr が true なら :white / :utriangle、false なら :black / :circle にする
# [var ? :true : :false for var in array]について
#   ? : 三項演算子
#   [for for var in array] : 内包表記
colors  = [t ? :white : :black  for t in type_tr]
markers = [t ? :utriangle : :circle for t in type_tr]

# ---(2) マークを区別してプロット---
scatter(glu_tr, bmi_tr, 
xlabel="glu",
ylabel="bmi",
color=colors,
marker=markers,
label=false,    # 凡例を表示しない
title="Pima Diagnosis of Diabetes",
size=(480,480), # 描画サイズを指定
aspect_ratio=:auto # アスペクト比を自動（auto）に指定
)


# ---3. 識別境界の計算---
#=
図4.9
2次元正規分布関数から得られるベイズ識別境界の例
=#

#C_no : type_tr[i]=false（糖尿病を発症しなかった人のクラス）⇒C_1=C_no
#C_yes : type_tr[i]=true（糖尿病を発症した人のクラス）⇒C_2=C_yes


# ---(1) クラスごとの平均ベクトル---
# Juliaではmean()とfilter()を組み合わせてクラスごとの平均を求めることができる
# μ_no = [mean(glu_tr[type_tr .== false]); mean(bmi_tr[type_tr .== false])]
# μ_yes = [mean(glu_tr[type_tr .== true]); mean(bmi_tr[type_tr .== true])]
# ここではp.37の方法で平均ベクトルを求める

# データ数
N = length(glu_tr)
# 各クラスのデータ数
# filter() : 条件に合う要素を抽出する関数
N_no = length(filter(t -> t == false, type_tr))  # type_trがfalseの数
N_yes = length(filter(t -> t == true, type_tr))   # type_trがtrueの数

# 平均ベクトル
# `type_tr .`で配列type_tr の各要素に対して条件式を適用する（ブロードキャスト）
μ_no = [sum(glu_tr[type_tr .== false]) / N_no; sum(bmi_tr[type_tr .== false]) / N_no]
μ_yes = [sum(glu_tr[type_tr .== true]) / N_yes  / N_yes; sum(bmi_tr[type_tr .== true]) / N_yes]


# ---(2) クラスごとの共分散行列---
# Juliaではcov()とfilter()を組み合わせてクラスごとの共分散行列を求めることができる
# cov()を使う場合はStatisticsをusingする必要がある
# using Statistics
# VSCodeのcov()を使用した以下のリコメンドコードのままだとエラーになる（配列の次元が合わない）
# Σ_no = cov(filter(t -> t == false, type_tr), [glu_tr; bmi_tr])
# Σ_yes = cov(filter(t -> t == true, type_tr), [glu_tr; bmi_tr])
# cov()を使用する場合は、クラスごとにデータを抽出してから共分散行列を求める必要がある
# データ抽出
data_no = [glu_tr[type_tr .== false]'; bmi_tr[type_tr .== false]']  # 2行N_no列の行列
data_yes = [glu_tr[type_tr .== true]'; bmi_tr[type_tr .== true]']    # 2行N_yes列の行列
# 共分散行列
# Σ_no = cov(data_no')
# Σ_yes = cov(data_yes')
# ここではp.37の方法で共分散行列を求める

# mean(),var()を使う場合はStatisticsをusingする必要がある
# using Statistics
# 発症しなかった人のglu_trを抽出
glu_no = glu_tr[type_tr .== false]
# 発症しなかった人のglu_trの平均μと分散var(σ^2)
μ_glu_no = mean(glu_no)
var_glu_no = var(glu_no)
# 発症しなかった人のbmi_trを抽出
bmi_no = bmi_tr[type_tr .== false]
# 発症しなかった人のbmi_trの平均μと分散var(σ^2)
μ_bmi_no = mean(bmi_no)
var_bmi_no = var(bmi_no)
# glu_noとbmi_no=bmi_noとglu_noの共分散cov_no
cov_no = sum((glu_no .- μ_glu_no) .* (bmi_no .- μ_bmi_no)) / (length(glu_no) - 1)
# 共分散行列Σ_no
Σ_no = [var_glu_no cov_no;
 cov_no var_bmi_no]
# 平均ベクトルμ_no
μ_no = [μ_glu_no; μ_bmi_no]

# 発症した人のglu_trを抽出
glu_yes = glu_tr[type_tr .== true]
# 発症した人のglu_trの平均μと分散var(σ^2)
μ_glu_yes = mean(glu_yes)
var_glu_yes = var(glu_yes)
# 発症した人のbmi_trを抽出
bmi_yes = bmi_tr[type_tr .== true]
# 発症した人のbmi_trの平均μと分散var(σ^2)
μ_bmi_yes = mean(bmi_yes)
var_bmi_yes = var(bmi_yes)
# glu_yesとbmi_yesの共分散cov_yes
cov_yes = sum((glu_yes .- μ_glu_yes) .* (bmi_yes .- μ_bmi_yes)) / (length(glu_yes) - 1)
# 共分散行列Σ_yes
Σ_yes = [var_glu_yes cov_yes;
 cov_yes var_bmi_yes]
# 平均ベクトルμ_yes
μ_yes = [μ_glu_yes; μ_bmi_yes]


# ---(3) クラスごとの事前確率---
# クラスC_noの事前確率P(C_no)
P_C_no = N_no / N
# クラスC_yesの事前確率P(C_yes)
P_C_yes = N_yes / N


# ---(4) 識別境界---
# 式4.32
# 行列S
S_quadratic = inv(Σ_no) - inv(Σ_yes)

# ベクトルC^T
C_T_quadratic = (transpose(μ_yes) * inv(Σ_yes)) - (transpose(μ_no) * inv(Σ_no))

# スカラーF
# 行列式の対数はlogdet()で求めることができる（行列式の計算は数値的に不安定な場合があるため、対数を取ることで安定化させる）
# logdet()を使う場合にはLinearAlgebraをusingする必要がある
# using LinearAlgebra
F_quadratic = (transpose(μ_no) * inv(Σ_no) * μ_no) - (transpose(μ_yes) * inv(Σ_yes) * μ_yes) + (logdet(Σ_no) - logdet(Σ_yes)) - 2 * log(P_C_no / P_C_yes)

# 識別境界関数
S = S_quadratic
C_T = C_T_quadratic
F = F_quadratic
function f_ij(x)
    f_decisionboundary = transpose(x) * S * x + 2 * C_T * x + F
    return f_decisionboundary[1]  # 行列演算の結果は1×1行列になるので[1]でスカラーとして返す
end


# ---4. 識別境界のプロット---
# ---4.1 図4.9(a)　2次識別関数の等高線---
# ---(1) 識別境界を描画するためのグリッドを作成---
glu_grid = range(50, 200, length=100)
bmi_grid = range(15.0, 50.0, length=100)

# ---(2) グリッド全体に対して識別境界関数f_ijを適用して高さの行列zを計算---
z = [f_ij([glu, bmi]) for bmi in bmi_grid, glu in glu_grid]

# ---(3) 識別境界を等高線で描画---
# 学習データの再プロット
scatter(glu_tr, bmi_tr, 
xlabel="glu",
ylabel="bmi",
color=colors,
marker=markers,
label=false,    # 凡例を表示しない
title="Pima Diagnosis of Diabetes",
size=(480,480), # 描画サイズを指定
aspect_ratio=:auto # アスペクト比を自動（auto）に指定
)

# 等高線描画
# contour() : 等高線を描画する関数
# レベル（等高線の位置）を -10 から 6 まで 2刻みで指定
contour_levels = -10.0:2.0:6.0
contour!(glu_grid, bmi_grid, z,
 levels=contour_levels,
 color=:black,
 linewidth=1,
 colorbar=false
)

# 識別境界を赤色の太線で強調表示
contour!(glu_grid, bmi_grid, z,
 levels=[0.0],
 color=:red,
 linewidth=2,
 colorbar=false
)

# ---4.2 図4.9(b)　線形識別関数の等高線---
# ---(1) 共通の共分散の計算---
Σ_common = (N_no * Σ_no + N_yes * Σ_yes) / N

# ---(2) 線形識別関数のパラメーターの計算---
# 行列S
S_linear = inv(Σ_common) - inv(Σ_common)  # 共通の共分散を使うのでSはゼロ行列になる

# ベクトルC^T
C_T_linear = (transpose(μ_yes) * inv(Σ_common)) - (transpose(μ_no) * inv(Σ_common))

# スカラーF
F_linear = (transpose(μ_no) * inv(Σ_common) * μ_no) - (transpose(μ_yes) * inv(Σ_common) * μ_yes) + (logdet(Σ_common) - logdet(Σ_common)) - 2 * log(P_C_no / P_C_yes)    # 共通の共分散を使うので行列式の差はゼロになる

# ---(3) 線形識別関数の定義---
# S,C_T,Fが計算できればあえて線形識別用の関数を定義する必要はない
# function f_ij_linear(x)
#     f_decisionboundary = transpose(x) * S * x + 2 * C_T * x + F
#     return f_decisionboundary[1]  # 行列演算の結果は1×1行列になるので[1]でスカラーとして返す
# end

# ---(4) グリッド全体に対して識別境界関数f_ijを適用して高さの行列zを計算---
S = S_linear
C_T = C_T_linear
F = F_linear
z = [f_ij([glu, bmi]) for bmi in bmi_grid, glu in glu_grid]

# ---(5) 線形識別関数の等高線を描画---
# 学習データの再プロット
scatter(glu_tr, bmi_tr, 
xlabel="glu",
ylabel="bmi",
color=colors,
marker=markers,
label=false,    # 凡例を表示しない
title="Pima Diagnosis of Diabetes",
size=(480,480), # 描画サイズを指定
aspect_ratio=:auto # アスペクト比を自動（auto）に指定
)

# レベル（等高線の位置）を -10 から 6 まで 2刻みで指定
contour_levels = -10.0:2.0:6.0
contour!(glu_grid, bmi_grid, z,
 levels=contour_levels,
 color=:gray,
 linestyle=:dash,
 linewidth=1,
 colorbar=false,
)

# 識別境界を赤色の太線で強調表示
contour!(glu_grid, bmi_grid, z,
 levels=[0.0],
 color=:blue,
 linestyle=:dash,
 linewidth=2,
 colorbar=false
)