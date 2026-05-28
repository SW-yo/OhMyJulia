# pima.tr.csvのファイルパスを設定する
filepath = joinpath(@__DIR__, "diabetes.csv")

# do io : 操作が終わったらファイルを閉じる
open(filepath, "r") do io
    #eachline : 行ごとに読み出す
    #keep=true  : 最後の改行\nを残す
    #first(eachline(io), i) : i行目まで読み出す
    for  line in first(eachline(io, keep=true), 6)
        print(line)
    end
end

# タイトル行を無視する方法（１）
open(filepath, "r") do io
    #Iterators.drop : 指定した行までは捨てる
    #Iterators.を付けない場合はusing Base.Iterators: dropでインポートしておく
    for  line in first(Iterators.drop(eachline(io, keep=true), 1), 3)
        print(line)
    end
end

# タイトル行を無視する方法（２）
open(filepath, "r") do io
    for  (i, line) in enumerate(eachline(io))
        if 2 <= i <= 5
            println(line)
        elseif i > 5
            break
        end
    end
end