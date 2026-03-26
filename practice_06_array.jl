# 基本形
x = [10, "march", 3.14]

x[1]
x[2]
x[3]

# 辞書
d = Dict()
d["xyz"] = 123    # 数字もOK
d["name"] = "frieren"    # 文字列もOK

d = Dict("apple" => 100, "banana" => 200)
println(d["banana"])
println(d["apple"])

for (key, value) in d
    println(key, ":", value)
end

# イテレータ
keys(d)
values(d)

# タプル
t = (1, 2, "Julia")

t_single = (1,)    # 要素が1つだけの場合はカンマが必要

# 関数の戻り値をタプルで返す
function get_pos()
    return (100, 200)
end

x, y = get_pos()

# 名前のついたタプル
# 作成
person = (name="Taro", age=25)

# 参照（ドットでアクセスできる！）
println(person.name) # "Taro"