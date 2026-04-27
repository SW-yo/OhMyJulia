# 基本形
function f(x)
    y = 1 / x + 3 * x
    return y
end

function f(x)
    return 1 / x + 3x
end

f(x) = 1 / x + 3x

f(3)


# 引数が複数
function say(str, num)
    for i in 1:num
        println(str)
    end
end

say("あら", 5)


# 戻り値が複数
function  split(vec, k)
    v1 = vec[1:k]
    v2 = vec[k+1:end]
    return v1, v2
end

x = [1; 2; 3; 4; 5]
x1, x2 = split(x, 2)
println(x1)
println(x2)