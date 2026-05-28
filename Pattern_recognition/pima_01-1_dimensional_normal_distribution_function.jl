#=
第4章　確率モデルと識別関数
p.46 1次元正規分布関数
=#

using Pkg
Pkg.activate(@__DIR__) # このファイルがあるフォルダの環境を有効化
using Plots, StatsPlots # 可視化パッケージ
gr()    # バックエンドの指定

function N_1dim(x, μ, σ)
    # 1次元分布正規関数
    # μ : 平均ベクトル
    # σ : 標準偏差

    N = (1 / √(2π * σ^2)) * exp((-(x - μ)^2 / (2σ^2)))

    # exp() : 指数関数
    # ここに処理を追加する場合はreturnでNを返すが、1行の計算は省くのが一般的
end

xs = range(-20.0, 20.0, length=100) # length=100は「データを100個持つ」という指定


#=
図4.7(a)
標準偏差σ=2で平均を変えた場合および平均μ=0で標準偏差を変えた場合のの正規分布関数
✓Nをドット関数でブロードキャストする
✓プロットを重ねる場合はPlot!()を使う）
=#

#平均を変化
σ = 2

μ = -10
plot(xs, N_1dim.(xs, μ, σ), label="μ=$μ, σ=$σ", title="1-Dimensional Normal Distribution")

μ = 0
plot!(xs, N_1dim.(xs, μ, σ), label="μ=$μ, σ=$σ")

μ = 10
plot!(xs, N_1dim.(xs, μ, σ), label="μ=$μ, σ=$σ")

#標準偏差を変化
μ = 0

σ = 4
plot!(xs, N_1dim.(xs, μ, σ), label="μ=$μ, σ=$σ")

σ = 8
plot!(xs, N_1dim.(xs, μ, σ), label="μ=$μ, σ=$σ")