import torch

import torch
import time

import os
# from dotenv import load_dotenv

# Cargar variables desde .env
# load_dotenv()

print(f"PYTHON_APP: {os.getenv("PYTHON_APP")}")


print(torch.__version__)
print(torch.cuda.is_available())

# Configurar dispositivo CUDA
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Crear tensores grandes para simular carga
size = 8192  # Aumentar para más carga
A = torch.randn(size, size, device=device)
B = torch.randn(size, size, device=device)

# Sincronizar antes de medir tiempo
torch.cuda.synchronize()

start_time = time.time()

# Simulación de carga: multiplicaciones de matrices grandes en bucle
for _ in range(100):  # Aumentar para más carga
    C = A @ B  # Multiplicación de matrices en la GPU

# Sincronizar y medir tiempo
torch.cuda.synchronize()
end_time = time.time()

print(f"Tiempo de ejecución: {end_time - start_time:.4f} segundos")