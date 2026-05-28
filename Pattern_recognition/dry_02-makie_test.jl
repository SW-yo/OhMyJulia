using Pkg
Pkg.activate(@__DIR__) 
using CairoMakie # マーカーをアルファベットにするためのバックエンド
using Statistics    # 統計関数を使用するために必要（mean(), var(), cov()など）
using LinearAlgebra # 線形代数パッケージ（inv(), logdet()など）
using DataFrames # データフレームパッケージ（DataFrame()など）

x = 0.0:0.05:1.0
# y = rand(100)
y = x.^3

fig = Figure()
ax = Axis(fig[1, 1],)
# plt = scatter!(x, y)
plt = plot!(x, y)
fig