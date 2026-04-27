a = [1, 2, 3]
b = [4, 5, 6]

# 積
# c_matrixproduct = a * b    # 行列積は定義できずエラー
c_matrixproduct = a * b' # bを転置して行列積
c_hadamardproduct = a .* b # 要素積

# 和
# 以下の2つは同じ結果になる
c_sum1 = a + b # 要素和
c_sum2 = a .+ b  # 要素和

# 関数
function sum_of_sqrt(arr)
    r = sqrt(arr[1]) + sqrt(arr[2])
    return r
end

a = [4; 9]
b =[16,  25]
# c_test1 = sum_of_sqrt(a, b)   これはエラー
c_test2 = sum_of_sqrt.(a, b)    # これはa,bの第1要素、第2要素ごとの組み合わせ
# c_test3 = sum_of_sqrt.(a b)   # 空白区切りは文法的にエラー
c_test4 = sum_of_sqrt.((a, b))   # タプルで送るとa,bそれぞれを関数処理

# 同様の結果が得られる書き方
map(sum_of_sqrt, (a, b))    # map関数
[sum_of_sqrt(x) for x in (a, b)]    # 内包表記
