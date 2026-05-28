#=
第4章　確率モデルと識別関数
p.46 多次元正規分布関数
=#

using Pkg
Pkg.activate(@__DIR__) # このファイルがあるフォルダの環境を有効化
using LinearAlgebra # 線形代数パッケージ
using Plots, StatsPlots # 可視化パッケージ
gr()    # バックエンドの指定

function N_multi(x, μ, Σ, d)
    # 多次元分布正規関数
    # μ : 平均ベクトル
    # Σ : 共分散行列
    # d : 次元数
    # 指数部はマハラノビス距離を表す

    N = (1 / ((2π)^(d/2) * det(Σ)^(1/2))) * exp(-(1/2) * transpose(x - μ) * inv(Σ) * (x-μ))
    
    # det() : 行列式（LinearAlgebraが必要）、行列計算なのでabs()ではなくこちらを使う
    # abs() : 絶対値←今回は使わない
    # exp() : 指数関数
    # transpose() : 行列の転置
    # inv() : 逆行列

    return N[1] # 行列演算の結果は1×1行列になるので[1]でスカラーとして返す

end


#=
図4.7(a)
標準偏差σ=2で平均を変えた場合および平均μ=0で標準偏差を変えた場合のの正規分布関数
✓Nをドット関数でブロードキャストする
✓プロットを重ねる場合はPlot!()を使う）
=#

# # 1次元正規分布関数としてテスト
# d = 1   # 1次元正規分布

# xs = range(-20.0, 20.0, length=100) # length=100は「データを100個持つ」という指定

# Σ = 2

# μ = -10
# plot(xs, N_multi.(xs, μ, Σ, d), label="μ=$μ, Σ=$Σ", title="1-Dimensional Normal Distribution")



#=
図4.7(b)
2次元正規分布からサンプルされた100個のデータを確率の等高線と共に示す
=#

# パラメーター
d = 2   # 2次元正規分布
μ = [2; 1] # μはp.47の例示のママ。 [2 1]' （転置）で書くと行列扱いで型判定エラーになる。μ = [2, 1]でも可
Σ = [0.7068966 0.5172414;
0.5172414 1.7931034]    # Σはp.47の例示のママ

# --- ステップ1　等高線の描画（1次元におけるxsと同じ考え方） ---
x1_grid = range(0.0, 5.0, length=100)
x2_grid = range(-2.0, 4.0, length=100)

# 全グリッドに対して2次元正規分布関数N_multiを用いて高さの行列zsを計算
zs = [N_multi([x1, x2], μ, Σ, d) for x2 in x2_grid, x1 in x1_grid]

# 確率の等高線を描画
# (A)等高線contour関数（Plotsに含まれている）を使用
contour(x1_grid, x2_grid, zs,
xlabel="x1",
ylabel="x2",
title="2-Dimensional Normal Distribution",
aspect_ratio=:equal,    # 縦横比を1:1にする（描画が歪まないようにする）
fill=false  # 塗りつぶしの指定
)

# # (B)ヒートマップheatmap関数（Plotsに含まれている）を使用
# heatmap(x1_grid, x2_grid, zs,
# xlabel="x1",
# ylabel="x2",
# title="2-Dimensional Normal Distribution",
# c=:viridis, # カラーリングの指定
# aspect_ratio=:equal)


# --- ステップ2　サンプルデータのプロット ---
# 100個のサンプルデータを準備
# (A)単純に乱数でサンプルデータを作成する
xv = [(rand(), rand()) for _ in 1:100]
xv_x1 = [x[1] for x in xv]  # 各xvの第1要素抽出
xv_x2 = [x[2] for x in xv]  # 各xvの第2要素抽出

# (B)正規分布に従う点を作成する
using Distributions
dist = MultivariateNormal(μ, Σ)
data = rand(dist, 100)  # 2行100列の行列を生成

xv_x1 = data[1, :]
xv_x2 = data[2, :]

scatter!(xv_x1,xv_x2,
label="samples",
markersize=3,
markerstrokewidth=0,  # 点の縁取りを消す
alha=0.6,
color=:blue)

scatter!([μ[1]], [μ[2]],
color=:red,
marker=:star,
markersize=10,
markerstrokewidth=0,
label="mean μ")