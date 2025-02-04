% Docker y Nvidia CUDA
% Antonio Mudarra Machuca
% Febrero 15, 2025

# Taller GDG

## Quien soy

Soy Antonio Mudarra Machuca investigador en la Universidad de Jaén en el grupo de investigación SIMIDAT.

## Objetivos del taller

Mostrar las capacidades de **docker** para la ejecución de modelos de IA, simplificando todo el proceso de configuración de distintos entornos de desarrollo y ejecución.

------------------

## CUDA y Librerías

Instalación para Windows, accedemos a la web para estudiar como instalar el kit de desarrollo de CUDA de nvidia [CUDA GUIDE](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/), podemos descargar los drivers desde [CUDA Toolkit 12.8](https://developer.nvidia.com/cuda-downloads)

Con `control /name Microsoft.DeviceManager` > `Adaptadores de pantalla` podemos ver la gráfica que tiene nuestro equípo. Podemos ver todo el listado de productos de nvidia desde la web [cuda-gpus](https://developer.nvidia.com/cuda-gpus).

### Paquetes que incluye

- CUDA
  - CUDA Driver
  - CUDA Runtime (cudart)
  - CUDA Math Library (math.h)
- cuDNN
  - CUDA Deep Neural Network

------------------


### Sistemas operativos compatibles:

- Microsoft Windows 11 24H2, 22H2-SV2, 23H2
- Microsoft Windows 10 22H2
- Microsoft Windows WSL 2
- Ubuntu 20.04, 22.04, 24.04

------------------

### Descarga e instalación

Descarga e instalación para Windows [CUDA Installation Guide for Microsoft Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)


---

Descarga e instalación para Ubuntu

[NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)

```bash
## Ubuntu 20.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2004-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

```bash
## Ubuntu 22.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

```bash
## Ubuntu 24.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

```bash
## WSL 2
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

```bash
# Instalación 
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8
```

Tras la instalación es posible que se requiera un reinicio, podemos comprobar si los drivers de nvidia están instalados con el comando `nvidia-smi` (NVIDIA System Management Interface).

## OLLAMA

Ollama es un gestor de modelos LLM que permite descargar, ejecutar y desplegar modelo LLM fácilmente mediante un servidor que distribuye una [API](https://github.com/ollama/ollama/blob/main/docs/api.md).

Esta tecnologia nos permite simplicar mucho la distribución de modelos para distintos usos.

![OLLAMA](./assets/ollama.png)

## Docker

```bash
docker compose build runner
docker compose up runner -d
docker compose exec runner bash
docker compose exec runner python -c "import torch; print(torch.cuda.is_available())"


#x = torch.rand(100, 100, 100, device='cuda:0');                                            \
#del x;                                                                                     \
#torch.cuda.reset_max_memory_allocated(0);                                                  \

docker compose exec runner python -c \
"import torch;                                                                             \
from tabulate import tabulate;                                                             \
info_cuda = [                                                                              \
    ['torch.__version__', torch.__version__],                                              \
    ['torch cuda is_available', torch.cuda.is_available()],                                \
    ['torch cuda current_device', torch.cuda.current_device()],                            \
    ['torch cuda device_count', torch.cuda.device_count()],                                \
    ['torch cuda get_device_name', torch.cuda.get_device_name(0)],                         \
    ['torch cuda is_initialized', torch.cuda.is_initialized()],                            \
    ['torch cuda memory_allocated', torch.cuda.memory_allocated(0)],                       \
    ['torch cuda memory_reserved', torch.cuda.memory_reserved(0)],                         \
    ['torch cuda max_memory_allocated', torch.cuda.max_memory_allocated(0)],               \
    ['torch cuda max_memory_reserved', torch.cuda.max_memory_reserved(0)],                 \
    ['torch backends cpu    get_cpu_capability', torch.backends.cpu.get_cpu_capability()], \
    ['torch backends cudnn  is_available', torch.backends.cudnn.is_available()],           \
    ['torch backends mkl    is_available', torch.backends.mkl.is_available()],             \
    ['torch backends mkldnn is_available', torch.backends.mkldnn.is_available()],          \
    ['torch backends mps    is_available', torch.backends.mps.is_available()],             \
    ['torch backends openmp is_available', torch.backends.openmp.is_available()],          \
];                                                                                         \
print(tabulate(info_cuda, headers=['Variable', 'Value']))                                  \
"

```

## docker compose de un chat-gpt propio

```yaml
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: ${PROJECT_NAME}_open-webui
    volumes:
      - local-open-webui:/app/backend/data
    depends_on:
      - ollama
    ports:
      - ${OPEN_WEBUI_PORT-3000}:8080
    environment:
      - 'OLLAMA_BASE_URL=http://ollama:11434'
    extra_hosts:
      - host.docker.internal:host-gateway
    restart: unless-stopped

  ollama:
    image: ollama/ollama:latest
    container_name: ${PROJECT_NAME}_ollama
    volumes:
      - local-ollama:/root/.ollama
    pull_policy: always
    tty: true
    restart: unless-stopped
    # GPU support
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities:
                - gpu
volumes:
  local-ollama:
    external: false
  local-open-webui:
    external: false

```



## Traefik

Para traefik debemos añadir la redireccion al servicio, con ubuntu/debian `sudo nano /etc/hosts` y para Windows abrir editor de texto con permisos de administrador el fichero `C:\Windows\System32\drivers\etc\hosts` y añadir la 

```bash
# Añadimos el host
127.0.0.1 chat.nonodev96.dev
```

## Referencias

- [CUDA GUIDE](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/).
- [cuDNN](https://developer.nvidia.com/cudnn).
- [OPEN WEB UI](https://docs.openwebui.com/).