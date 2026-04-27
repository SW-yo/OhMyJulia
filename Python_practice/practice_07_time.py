import numpy as np
import time

# Numpyを使う
A = np.random.rand(1000, 1000)
B = np.random.rand(1000, 1000)

start = time.time()
C = np.dot(A, B)  # または A @ B
end = time.time()

print(f"Numpy（1000x1000）の計算時間: {end - start:.4f}s")


# Numpyを使わない素のPython
import time

size = 500  # 1000だと終わらないかもしれないので500で
A_list = [[i for i in range(size)] for j in range(size)]
B_list = [[i for i in range(size)] for j in range(size)]
C_list = [[0 for i in range(size)] for j in range(size)]

start = time.time()
for i in range(size):
    for j in range(size):
        for k in range(size):
            C_list[i][j] += A_list[i][k] * B_list[k][j]
end = time.time()

print(f"素のPython（500x500）の計算時間: {end - start:.4f}s")