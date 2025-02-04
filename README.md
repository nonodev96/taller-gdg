% Docker y NVIDIA
% Antonio Mudarra Machuca
% Febrero 15, 2025

# Taller GDG

## Quien soy

Soy Antonio Mudarra Machuca investigador en la Universidad de Jaén en el grupo de investigación SIMIDAT.

## Objetivos del taller

Mostrar las capacidades de **docker** para la ejecución de modelos de IA, simplificando todo el proceso de configuración de distintos entornos de desarrollo y ejecución.

- Entender y manejar docker.
- Comprender la diferencia entre imágenes y contenedores.
- Gestionar recursos de un contenedor.
- Conococer recursos de nvidia para el desarrollo y despliegue de modelos.
- Conocer otras herramientas como ollama o traefik.


## Introducción a docker

![Funcionamiento de docker](./assets/docker-architecture.png)

![Virtual machines vs Containers](./assets/virtual-machines-vs-containers.png)

---

Instalación de docker engine en Ubuntu

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

---

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

---

Instalación de los paquetes de la comunidad en ubunutu

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Ejecución de una imágen para crear un contenedor

```bash
sudo docker run hello-world
```

Modificar los grupos para no necesitar permisos sudo al desplegar los contenedores.

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker          # Activamos los cambios del grupo
docker run hello-world # ya no hace falta ejecutar con permisos sudo
```

---

Si te aparece el siguiente warning es posible que se deba a que has ejecutado un contenedor previamente con permisos de administrador, puedes corregirlo modificando los permisos de la carpeta `~/.docker/`

```ansi
WARNING: Error loading config file: /home/user/.docker/config.json -
stat /home/user/.docker/config.json: permission denied
```

```bash
# eliminas o cambias los permisos
sudo rm -rf /home/"$USER"/.docker

sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "/home/$HOME/.docker" -R
```

---

Instalación de docker desktop en windows, siguiente, siguiente, siguiente.

- [Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

---

## NVIDIA CUDA y Librerías

Instalación de CUDA, accedemos a la web para estudiar como instalar el kit de desarrollo de CUDA de nvidia, podemos descargar los drivers desde [CUDA Toolkit 12.8](https://developer.nvidia.com/cuda-downloads)

Para ver todo el listado de productos de nvidia con soporte de cuda podemos acceder a la web [cuda-gpus](https://developer.nvidia.com/cuda-gpus).

- [CUDA GUIDE WINDOWS](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)
- [CUDA GUIDE LINUX](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)

### Sitemas operativos

Para Windows podemos abri el panel de dispositivos con `control /name Microsoft.DeviceManager` > `Adaptadores de pantalla`.

Con Debian y derivados podemos ver la gráfica con `lspci | grep VGA` o con el paquete `hwinfo` instalando (`sudo apt install hwinfo`) y comprobando el hardware (`sudo hwinfo --gfxcard`).

```bash
lspci | grep VGA
lspci | grep -i nvidia
sudo apt install hwinfo
sudo hwinfo --gfxcard
```

---

Para ambos casos windows o linux, se instala la orden `nvidia-smi` que nos permite ver que hardware tiene nuestro equipo y como lo está usando. En la parte superior nos indica la versión máxima soportada por nuestra tarjeta, no indica la versión instalada.

```bash
nvidia-smi
nvcc --version
```

---

### Sistemas operativos compatibles:

- Ubuntu 20.04, 22.04 y 24.04 # <- Recomendado
- Microsoft Windows 11 24H2, 22H2-SV2 y 23H2
- Microsoft Windows 10 22H2
- Microsoft Windows WSL 2
- Debian 11 y 12
- RHEL / Rocky, KylinOS, Fedora, SLES, OpenSUSE, Amazon Linux, Azure Linux CM2.

---

### Paquetes que incluye

- CUDA
  - CUDA Driver
  - CUDA Runtime (cudart)
  - CUDA Math Library (math.h)
- cuDNN
  - CUDA Deep Neural Network

---

### Descarga e instalación

Descarga e instalación de CUDA para Windows [CUDA Installation Guide for Microsoft Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)

---

Descarga e instalación de CUDA para Linux [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)

Instalación de drivers mediante `ubuntu-drivers` [nvidia-drivers-installation](https://ubuntu.com/server/docs/nvidia-drivers-installation)

---

Ubuntu 20.04

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2004-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

Ubuntu 22.04

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

Ubuntu 24.04

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

WSL 2

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

```bash
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8
```

Tras la instalación es posible que se requiera un reinicio, podemos comprobar si los drivers de nvidia están instalados con el comando `nvidia-smi` (NVIDIA System Management Interface).

## Docker NVIDIA


![DOCKER NVIDIA Toolkit](./assets/docker-nvidia-toolkit.png)

---

Ejemplo básico

```bash
docker run --gpus all --rm -ti nvcr.io/nvidia/pytorch:24.04-py3
# Configuración de las Gráficas
docker run --gpus 2 ...
docker run --gpus "device=1,2" ...
docker run --gpus "device=UUID-ABCDEF,1" ...

#      Crear el contenedor
#      |   Todas las GPUs
#      |   |          Modo interactivo
#      |   |          |   Eliminar le contenedor despues de usarlo
#      |   |          |   |    permisos del usuario y grupo
#      |   |          |   |    |                    Imagen a ejecutar
#      |   |          |   |    |                    |
#      v   v          v   v    v                    v
docker run --gpus all -ti --rm -u $(id -u):$(id -g) nvcr.io/nvidia/pytorch:24.04-py3
# Puede aparecer esta advertencia "groups: cannot find name for group ID 1000 I have no name!", puedes ignorarla
```

![docker run](./assets/docker-run.png)

---

## Docker compose

```bash
# Obtener más información
docker compose [orden] --help
# Contruir los contenedores
docker compose build [servicio]
# Parar las imágenes y eliminar los contenedores
docker compose down [servicio]
# El `-d` significa que es en segundo plano
docker compose up [servicio] -d
```

---

Dockerfile genérico

```dockerfile
FROM <imagen>

# Espacio de trabajo donde se iniciará el contenedor una vez creada la imagen
WORKDIR /workspace

# Ejemplo de comanndo durante la creación de la imagen
RUN sudo apt install screen -y

# Ejemplo de ENTRYPOINT con CMD
# Por defecto ENTRYPOINT es `/bin/sh -c`
ENTRYPOINT ["/bin/echo"]
CMD ["Hello"]
```

## NVIDIA CATALOG

[Catálogo de contenedores de NVIDIA](https://catalog.ngc.nvidia.com/)

## NVIDIA-Pytorch

```yaml
services:
  runner_pytorch:
    container_name: ${PROJECT_NAME}_runner_pytorch
    build:
      context: ./Apps/runner-pytorch
      dockerfile: Dockerfile
    command: bash
    stdin_open: true
    tty: true
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./Apps/runner-pytorch/workspace:/workspace
    # Para compartir memoria entre procesos en multihilo
    ipc: host
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities:
                - gpu
```

---

## NVIDIA-TensorFlow

```yaml
services:
  runner_tensorflow:
    container_name: ${PROJECT_NAME}_runner_tensorflow
    build:
      context: ./Apps/runner-tensorflow
      dockerfile: Dockerfile
    command: bash
    stdin_open: true
    tty: true
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./Apps/runner-tensorflow/workspace:/workspace
    ipc: host
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities:
                - gpu
```

---

## NVIDIA-RAPIDSAI

La imagen `rapidsai/base` contiene una shell de `ipython` de manera predeterminada.
La imagen `rapidsai/notebooks` contiene el servidor de `JupyterLab` de manera predeterminada.

```md
24.12-cuda12.5-py3.12
^ ^ ^
| | Python version
| |
| CUDA version
|
RAPIDS version
```

---

```yaml
services:
  runner_rapidsai:
    container_name: ${PROJECT_NAME}_runner_rapidsai-notebook
    image: nvcr.io/nvidia/rapidsai/notebooks:24.12-cuda12.5-py3.12
    #build:
    #  context: ./Apps/runner-3-rapidsai
    #  dockerfile: Dockerfile
    ports:
      - 8888:8888
    stdin_open: true
    tty: true
    ipc: host
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      # Paquetes extra de conda a instalar
      - EXTRA_CONDA_PACKAGES=jq
      # Espera de 5 segundos tras instalar paquetes de conda.
      - CONDA_TIMEOUT=5
      # Paquetes extra de pip a instalar
      - EXTRA_PIP_PACKAGES=tabulate
      # Espera de 5 segundos tras instalar paquetes de pip.
      - PIP_TIMEOUT=5
    # Configuramos la memoria compartida
    shm_size: "1gb"
    ulimits:
      # Permitir el bloqueo ilimitado de la memoria
      memlock: -1
      # Tamaño de la pila en bytes
      stack: 67108864
    volumes:
      - ./Apps/runner-3-rapidsai/workspace:/workspace
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

## DEV Container

![DevContainers](./assets/architecture-containers.png)

## OLLAMA

Ollama es un gestor de modelos LLM que permite descargar, ejecutar y desplegar modelo LLM fácilmente mediante un servidor que distribuye una [API](https://github.com/ollama/ollama/blob/main/docs/api.md).

Esta tecnologia nos permite simplicar mucho la distribución de modelos para distintos usos.

![OLLAMA](./assets/ollama.png)

## Ejemplo de docker compose de un chat-gpt propio

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
      - "OLLAMA_BASE_URL=http://ollama:11434"
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

- [CUDA GUIDE Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/).
- [CUDA GUIDE Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/).
- [cuDNN](https://developer.nvidia.com/cudnn).
- [OPEN WEB UI](https://docs.openwebui.com/).
- [Catálogo de contenedores de NVIDIA](https://catalog.ngc.nvidia.com/)
- [VSCODE Extensión Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
