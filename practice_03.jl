# if
a = 8
if a > 5
	println("そのとおり")
end

# else
s = "fuga" 
if s == "hoge"
    println("Hoge!")
else
    println("Not Hoge!")
end

# else if
x = 0.5
if x < 0.3
	println("xは小さい")
elseif x < 0.7
	println("xは中くらい")
else
	println("xは大きい")
end

# while
i = 1
while i <= 5
	println(i) 
    i += 1
end

# for
for i in 1:5
	println(i)
end

x = [10; 20; 30; 40; 50]
for v in x
	println(v)
end

x = [10; 20; 30; 40; 50]
for i in 1:5
	println(x[i])
end

# 二重ループ
for i in 1:2
	for j in 1:3
		println("i=", i, ", j=", j)
	end
end

for i in 1:2, j in 1:3
	println("i=", i, ", j=", j)
end

# 行列表示
A = [1 2 3;
4 5 6;
7 8 9]

# これだと列→行の順で要素の抜き出しになる。
# Juliaは列優先で処理をする。
for v in A
    println(v)
end

# この書き方は縦に1列の要素の抜き出しになる。
for  i in 1:1
    for v in A[i:i, 1:3]
        println(v)
        println(v')
    end
end

# 地道にやる方法
for i in 1:size(A, 1)        # 行の数だけループ
    row = A[i, :]            # i行目の全列を取り出す
    println(join(row, "  ")) # 要素をスペースでつないで1行で表示
end

# 地道を1行ループで書く方法
# 行i と 列j を同時に回す
for i in 1:3, j in 1:3
    print(A[i, j], " ")
    if j == 3
        println() # 3列目まで行ったら改行
    end
end

#  eachrow(A) を使うと、v に「1行分」が順番に入る。
for v in eachrow(A)
    println(v)
end

# v には [1, 4, 7], [2, 5, 8], [3, 6, 9] が順番に入る。
for v in eachcol(A)
    println(v)
end

# 出力だけならこれが一番ちゃんしている。
display(A)