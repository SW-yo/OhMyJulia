sentence="次回は線形代数（大学受験？）の問題について、チームで取り組んでもらいます。現在線形代数の講義で使っている教科書とか、あるいは発展的なトピックでもよいので関連しそうな数学の本などを持ってきてください。"

# 方法A
# 4文字目から7文字目まで
s_start = nextind(sentence, 0, 4) # 4文字目の開始バイト位置
s_end   = nextind(sentence, 0, 7) # 7文字目の開始バイト位置```

println(sentence[s_start:s_end]) # これで「線形代数」が出る

# 方法B
chars = collect(sentence)
println(join(chars[4:7])) # 配列を結合して表示

# 方法C
range = findfirst("線形代数", sentence)
println(sentence[range])