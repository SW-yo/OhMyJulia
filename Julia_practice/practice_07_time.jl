A = rand(1000, 1000)
B = rand(1000, 1000)
# @time C = A * B

using BenchmarkTools
@benchmark C = A * B