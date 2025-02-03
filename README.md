# Taller GDG

## Quien soy

Soy Antonio mudarra machuca investigador en la Universidad de Jaén en el grupo de investigación SIMIDAT




## CUDA

Instalación para Windows, accedemos a la web para estudiar como instalar el kit de desarrollo de CUDA de nvidia [CUDA GUIDE](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/), podemos descargar los drivers desde [CUDA Toolkit 12.8](https://developer.nvidia.com/cuda-downloads)

Con `control /name Microsoft.DeviceManager` > Adaptadores de pantalla podemos ver la gráfica que tiene nuestro equípo. Podemos ver todo el listado de productos de nvidia desde la web [cuda-gpus](https://developer.nvidia.com/cuda-gpus).


### Paquetes que incluye

- CUDA Driver
- CUDA Runtime (cudart)
- CUDA Math Library (math.h)

### Sistemas operativos compatibles:

- Microsoft Windows 11 24H2, 22H2-SV2, 23H2
- Microsoft Windows 10 22H2
- Ubuntu 20.04, 22.04, 24.04

### Instalación 

```bash
## Ubuntu 20.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2004-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/

## Ubuntu 22.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/

## Ubuntu 24.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/

# Instalación 
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8

```

## Docker 

```bash

```


## docker compose 

```yaml
services:
  openWebUI:
    image: ghcr.io/open-webui/open-webui:main
    container_name: ${PROJECT_NAME}_open_web_ui
    restart: always
    ports:
      - "3000:8080"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    volumes:
      - open-webui-local:/app/backend/data
```

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


## Referencias

- [CUDA GUIDE](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/).