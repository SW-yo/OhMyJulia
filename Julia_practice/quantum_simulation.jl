fidelity = 1.0
for i in 1:1000
    fidelity = fidelity * 0.999
end
println(fidelity * 100 , "%")