using CairoMakie
using Colors

# Float64精度不足
# function tupper(x, y)
#     tupper = 1/2 - floor(mod(floor(y/17) *  2 ^ (-17 * floor(x) - mod(floor(y), 17)), 2))
#     return tupper
# end

function tupper(x, y)
    n = 17 * BigInt(x) + mod(BigInt(y), 17)
    bit = div(div(BigInt(y), 17), BigInt(2)^n)
    return mod(bit, 2) == 1
end


k = 960939379918958884971672962127852754715004339660129306651505519271702802395266424689642842174350718121267153782770623355993237280874144307891325963941337723487857735749823926629715517173716995165232890538221612403238855866184013235585136048828693337902491454229288667081096184496091705183454067827731551705405381627380967602565625016981482083418783163849115590225610003652351370343874461848378737238198224849863465033159410054974700593138339226497249461751545728366702369745461014655997933798537483143786841806593422227898388722980000748404719

pix_value = falses(108, 18)

for i in 1:1:108
    for j = 1:1:18
        x = i - 1
        y = k + j - 1
        pix_value[i, j] = tupper(x, y)
    end
end

x_range = 0:107
y_range = 0:17

fig = Figure()
ax = Axis(fig[1, 1], aspect = DataAspect(), xreversed = true, yreversed = true)

# heatmap!バージョン
heatmap!(ax, x_range, y_range, pix_value,
         colormap = [RGBA(31.4/255, 3.0/255, 3.0/255, 0.7), :gray5])

#scatter!バージョン
# xs = [x for (i, x) in enumerate(x_range) for j in eachindex(y_range) if pix_value[i, j]]
# ys = [y_range[j] for (i, x) in enumerate(x_range) for j in eachindex(y_range) if pix_value[i, j]]
# scatter!(ax, xs, ys, markersize=8, color=:black, marker=:rect)

save("tupper.png", fig)
display(fig)
