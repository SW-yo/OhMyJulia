### 1.   
```
using CUDA
# 1000x1000のランダム行列をGPU上に作成
a_gpu = CUDA.rand(1000, 1000)
b_gpu = CUDA.rand(1000, 1000)

# GPUで更に行列演算
c_gpu = a_gpu * b_gpu

# 結果の確認
summary(c_gpu)
```