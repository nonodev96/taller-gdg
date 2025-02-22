---
marp: true
title: Docker y NVIDIA
author: Antonio Mudarra Machuca
description: 'Introducción a docker y el soporte de gráficas NVIDIA con CUDA'
backgroundImage: url('https://marp.app/assets/hero-background.svg')

paginate: true
---

<!-- 
_header: 'Taller GDG'
_footer: 'nonodev96'
-->

# Introducción a la IA con contenedores de alta eficiencia

[@nonodev96/taller-gdg](https://github.com/nonodev96/taller-gdg)

---

## Quien soy

<style scoped>

.instituciones {
  display: flex; 
  justify-content: space-around; 
  align-items: stretch;
}

</style>

Soy Antonio Mudarra Machuca investigador en la Universidad de Jaén en el grupo de investigación SIMIDAT.

![h:128px](./assets/gdg-jaén.png)

<div class="instituciones">
  <img src="./assets/simidat.png" width="25%" />
  <img src="./assets/uja.png" width="25%" />
  <img src="./assets/dasci.png" width="25%" />
</div>

---

## Objetivos del taller

Mostrar las capacidades de **docker** para la ejecución de modelos de IA, simplificando todo el proceso de configuración de distintos entornos de desarrollo y ejecución.

- ✅ Introducción a docker y contenedores especializados en IA
- ✅ Comprender la diferencia entre imágenes y contenedores
- ✅ Configuración de entornos con PyTorch, TensorFlow y herramientas clave
- ✅ Conocer recursos de nvidia para el desarrollo y despliegue de modelos
- ✅ Ejecución de modelos LLM en tu propio ordenador con ollama
- Breve introducción a la seguridad en modelos de IA
- Entender y manejar docker, gestionar recursos de un contenedor
- Conocer otras herramientas como ollama o traefik

---

## Motivación

- Facilidad de despliegue
- Aislamiento de dispositivos individuales
- Ejecución en entornos heterogéneos de controladores/toolkits
- Sólo requiere la instalación del controlador NVIDIA en el host
- Facilita la colaboración: compilaciones reproducibles, rendimiento reproducible, resultados reproducibles

---

## Introducción a docker

![Virtual machines vs Containers](./assets/virtual-machines-vs-containers.png)

---

![Funcionamiento de docker](./assets/docker-architecture.png)

---

Instalación de docker engine en Ubuntu

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

---

Descarga de los paquetes y actualización de las dependencias

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

Instalación de los paquetes de la comunidad en ubuntu

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Ejecución de una imagen para crear un contenedor

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

```
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

![Funcionamiento de docker](./assets/docker-architecture.png)

---

## Creación de imágenes con docker

Fichero `Dockerfile` genérico.

```dockerfile
FROM ubuntu:22.04

# Espacio de trabajo donde se iniciará el contenedor una vez creada la imagen
WORKDIR /workspace_nonodev96

# Por defecto ENTRYPOINT es `/bin/sh -c`
ENTRYPOINT ["/bin/bash", "-c"]

# Proporciona valores por defecto para un contenedor ejecutable. 
# Si no se especifica un ejecutable, también debe especificarse ENTRYPOINT.
# Solo puede haber una instrucción CMD en un Dockerfile.
CMD ["echo 'hello world!' >> /workspace_nonodev96/hello_world.txt"]
```

---

## NVIDIA CUDA y Librerías

Instalación de CUDA, accedemos a la web para estudiar como instalar el kit de desarrollo de CUDA de nvidia, podemos descargar los drivers desde [CUDA Toolkit 12.8](https://developer.nvidia.com/cuda-downloads)

Para ver todo el listado de productos de nvidia con soporte de CUDA podemos acceder a la web [cuda-gpus](https://developer.nvidia.com/cuda-gpus).

- [CUDA GUIDE WINDOWS](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)
- [CUDA GUIDE LINUX](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)

---

### Sistemas operativos

Para Windows podemos abrir el panel de dispositivos con `control /name Microsoft.DeviceManager` > `Adaptadores de pantalla`.

Con Debian y derivados podemos ver la gráfica con `lspci | grep VGA` o con el paquete `hwinfo` instalando (`sudo apt install hwinfo`) y comprobando el hardware (`sudo hwinfo --gfxcard`).

```bash
lspci | grep VGA
lspci | grep -i nvidia
sudo apt install hwinfo
sudo hwinfo --gfxcard
```

---

Para ambos casos windows o linux, se instala la orden `nvidia-smi` (NVIDIA System Management Interface).

Este nos permite ver que hardware tiene nuestro equipo y como lo está usando. En la parte superior nos indica la versión máxima soportada por los drivers de nuestra tarjeta, no indica la versión instalada.

```bash
nvidia-smi
nvcc --version # Este es el compilador, no viene con los drivers
```

---

### Sistemas operativos compatibles con el toolkit de CUDA:

- Ubuntu 20.04, **22.04** y 24.04 **⬅️ Recomendado**
- Microsoft Windows 11 24H2, 22H2-SV2 y 23H2
- Microsoft Windows 10 22H2
- Microsoft Windows WSL 2
- Debian 11 y 12
- RHEL / Rocky, KylinOS, Fedora, SLES, OpenSUSE, Amazon Linux, Azure Linux CM2.

---

### Paquetes que incluye

⚠️ Compatibilidad con los distintos sistemas operativos [cuda-toolkit-release-notes](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)

- CUDA
  - CUDA Driver
  - CUDA Runtime (cudart)
  - CUDA Math Library (math.h)
  - etc
- cuDNN
  - CUDA Deep Neural Network
- ⚠️ nvidia-container-toolkit (Este no lo incluye 👍 )

---

### Descarga e instalación

---

Descarga e instalación de CUDA para Linux [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)

Instalación de drivers mediante `ubuntu-drivers` [nvidia-drivers-installation](https://ubuntu.com/server/docs/nvidia-drivers-installation)

---

Ubuntu 24.04

```bash
sudo apt update && sudo apt install -y build-essential

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

WSL 2

```bash
sudo apt update && sudo apt install -y build-essential

wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
```

---

Tras la actualización de paquetes podemos instalar, instalamos con `apt`, es posible que se requiera un reinicio.

```bash
sudo apt-get update

# Repositorio oficial de nvidia
sudo apt-get -y install cuda-toolkit-12-8

# export PATH="/usr/local/cuda-12.8/bin:$PATH"
# export LD_LIBRARY_PATH="/usr/local/cuda-12.8/lib64:$LD_LIBRARY_PATH"

# Repositorio oficial de ubuntu (es más sencillo instalar nvcc en WSL)
sudo apt-get -y install nvidia-cuda-toolkit 
```

---

### Comprobar la instalación

```bash
nvcc --version

ls /usr/local/ | grep cuda
cd /etc/alternatives/cuda 
realpath $(pwd) # Con realpath podéis resolver todos los enlaces simbólicos
```

---

Descarga e instalación de CUDA para Windows [CUDA Installation Guide for Microsoft Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)

Viene con la instalación del `container-toolkit` en el WSL predeterminado.

Instalación: Siguiente, siguiente, siguiente. 

---

## Docker NVIDIA

![bg right contain](./assets/docker-nvidia-toolkit.png)

---

## Instalación del runtime para GPUs de nvidia

Descargar repositorio de `nvidia-container-toolkit` [container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

```bash
sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

Ejemplo básico

```bash
docker run --gpus all --rm -ti nvcr.io/nvidia/pytorch:25.01-py3
# Configuración de las Gráficas
docker run --gpus 2 ...
docker run --gpus "device=1,2" ...
docker run --gpus "device=UUID-ABCDEF,1" ...

docker run --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 --rm -ti nvcr.io/nvidia/pytorch:25.01-py3
```

---

## Errores comunes

```bash
docker run --gpus all -it --rm nvcr.io/nvidia/pytorch:25.01-py3
> docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]].
```

Hay que revisar la instalación del `nvidia-container-toolkit`

---

![docker run](./assets/docker-run.png)

Puede aparecer esta advertencia "groups: cannot find name for group ID 1000 I have no name!", puedes ignorarla

---

## Docker compose

Despliegue de soluciones con docker compose (orquestación).

```bash
# Obtener más información
docker compose [orden] --help

# Construir los contenedores
docker compose build [servicio]

# Parar los servicios y eliminar los contenedores
docker compose down [servicio]

# Levantar el servicio
docker compose up [servicio] -d # `-d` para segundo plano
```

---

## NVIDIA CATALOG

[Catálogo de contenedores de NVIDIA](https://catalog.ngc.nvidia.com/containers)

![Catálogo](./assets/ngc-catalog.png)

---

## Descargar imágenes

```bash
docker pull nvcr.io/nvidia/pytorch:25.01-py3      # 6 minutos aproximadamente
docker pull nvcr.io/nvidia/tensorflow:25.01-tf2-py3
docker pull nvcr.io/nvidia/rapidsai/notebooks:24.12-cuda12.5-py3.12

docker pull ollama/ollama
docker pull ghcr.io/open-webui/open-webui:main
```

```bash
# https://hub.docker.com/r/nvidia/cuda
docker pull nvidia/cuda:11.8.0-base-ubuntu22.04
```

---

## NVIDIA-Pytorch

```yaml
services:
  runner_pytorch:
    container_name: ${PROJECT_NAME}_runner_pytorch
    image: nvcr.io/nvidia/pytorch:25.01-py3
    # build:
    #   context: ./Apps/runner-pytorch
    #   dockerfile: Dockerfile
    command: bash
    stdin_open: true
    tty: true
    ipc: host # Para compartir memoria
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
    volumes:
      - ./Apps/runner-pytorch/workspace_pytorch:/workspace_pytorch
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

<div style="display: flex; justify-content: space-around;">
  <img src="./assets/logs_pytorch.png" width="60%" />
  <img src="./assets/test_pytorch.png" width="30%" />
</div>

---

## NVIDIA-TensorFlow

```yaml
services:
  runner_tensorflow:
    container_name: ${PROJECT_NAME}_runner_tensorflow
    # image: nvcr.io/nvidia/tensorflow:25.01-tf2-py3
    build:
      context: ./Apps/runner-tensorflow
      dockerfile: Dockerfile
    command: bash
    stdin_open: true
    tty: true
    ipc: host
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
    volumes:
      - ./Apps/runner-tensorflow/workspace_tensorflow:/workspace_tensorflow
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

<div style="display: flex; justify-content: space-around;">
  <img src="./assets/logs_tensorflow.png" width="30%" />
  <img src="./assets/test_tensorflow.png" width="60%" />
</div>

---

## NVIDIA-RAPIDSAI

La imagen `rapidsai/base` contiene una shell de `ipython` de manera predeterminada.
La imagen `rapidsai/notebooks` contiene el servidor de `JupyterLab` de manera predeterminada.

```
RAPIDS version
|     CUDA version
|     |        Python version
v     v        v
24.12-cuda12.5-py3.12
```

---

![bg contain](./assets/jupyter.png)

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
    ipc: host # Memoria compartida
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
      # - EXTRA_CONDA_PACKAGES=jq     # Paquetes extra de conda a instalar
      # - CONDA_TIMEOUT=5             # Espera de 5 segundos tras instalar paquetes de conda.
      # - EXTRA_PIP_PACKAGES=tabulate # Paquetes extra de pip a instalar
      # - PIP_TIMEOUT=5               # Espera de 5 segundos tras instalar paquetes de pip.
    shm_size: "1gb"
    ulimits:
      memlock: -1         # Permitir el bloqueo ilimitado de la memoria
      stack: 67108864     # Tamaño de la pila en bytes
    volumes:
      - ./Apps/runner-3-rapidsai/workspace_rapidsai:/workspace_rapidsai
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: 
                - gpu
```

---

## Ejemplo para la creación de un contenedor de desarrollo.

```bash
cd ./.devcontainer
docker build --no-cache 
             --tag i_taller_devcontainer
             --file ./Dockerfile-pytorch .

docker run --gpus=all 
           --ipc=host
           --ulimit memlock=-1
           --ulimit stack=67108864 
           --name runner_dev_pytorch
           -it -d i_taller_devcontainer 
```

> Podemos conectarnos mediante el entorno de desarrollo de vscode.

---

## DEV Container

![DevContainers](./assets/architecture-containers.png)

---

Debemos instalar la [extensión](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) de Microsoft para poder conectarnos a los contenedores mediante VSCode.

<div style="display: flex; justify-content: space-around;">
  <img src="./assets/remote-containers-readme.gif" width="75%" />
</div>

---

## Fichero devcontainer.json

Desde la carpeta `./.devcontainer` editamos el fichero `devcontainer.json`, este nos permite definir el comportamiento del contenedor y del IDE. [containers.dev](https://containers.dev/implementors/json_reference/). 

```json
{
  "name": "Dev PyTorch",
  // Argumentos con los que se crea la imagen 
  "build": {
    "dockerfile": "Dockerfile-pytorch",
    "args": {
      "DEVCONTAINER_CLI": "true"
    }
  },
  // Argumentos con los que se ejecuta el contenedor
  "runArgs": [ "--gpus=all", "--ipc=host", "--ulimit", "memlock=-1", "--ulimit", "stack=67108864" ],
  "containerEnv": {
    "TALLER_TOKEN": "${localEnv:TALLER_TOKEN}"
  },
  "remoteEnv": {
    "PATH": "${containerEnv:PATH}:/some/other/path"
  },
  /// ....
}
```

---

```json
{
  /// ....
  "postCreateCommand": [ 
    "nvidia-smi" 
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "terminal.integrated.profiles.linux": {
          "zsh": {
            "path": "/bin/zsh"
          }
        }
      },
      "extensions": [
        // "ms-vscode.makefile-tools",
        // ...
      ]
    }
  },
  /// ....
}
```

---

```json
{ 
  /// ....
  // 'mounts' Montar carpetas en el contenedor de desarrollo. Más información: https://containers.dev/implementors/json_reference/.
  "mounts": [
    // WINDOWS  --> USERPROFILE
    "source=${env:USERPROFILE}/.ssh,target=/home/ubuntu/.ssh,type=bind,consistency=cached",
    "source=${env:USERPROFILE}/.gitconfig,target=/home/ubuntu/.gitconfig,type=bind,consistency=cached"
    // LINUX    --> HOME
    "source=${env:HOME}/.ssh,target=/home/ubuntu/.ssh,type=bind,consistency=cached",
    "source=${env:HOME}/.gitconfig,target=/home/ubuntu/.gitconfig,type=bind,consistency=cached"
  ],
  // 'features' Funciones para añadir al contenedor de desarrollo. Más información: https://containers.dev/features.
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}   
  },
  // 'remoteUser' Descomentar para conectarse como root en su lugar. Más información: https://aka.ms/dev-containers-non-root.
  "remoteUser": "ubuntu"
}
```

---

### Comandos útiles

En el sistema anfitrión:

```bash
git config --global --add safe.directory /workspaces/taller-gdg
```

En el contenedor

```bash
printenv
echo "$(whoami) @ $(hostname) # $UID:$GID"

git config user.name
git config user.email
cat /home/ubuntu/.gitconfig

cat /etc/os-release
nvidia-smi
nvidia-smi topo -m
```

---

### Configuración del contenedor y del host.

- `containerEnv`: Para definir variables directamente en el contenedor.
  - Definir una variable solo en el contenedor
- `remoteEnv`: Para pasar variables desde el host al contenedor.
  - Usar una variable definida en el host `remoteEnv`
  - Configurar valores secretos sin guardarlos en el **DevContainer**

---

### Variables en devcontainer.json

| Variables                             |
| ------------------------------------- |
| `${localEnv:VARIABLE_NAME}`           |
| `${containerEnv:VARIABLE_NAME}`       |
| `${localWorkspaceFolder}`             |
| `${containerWorkspaceFolder}`         |
| `${localWorkspaceFolderBasename}`     |
| `${containerWorkspaceFolderBasename}` |
| `${devcontainerId}`                   |

---

## Docker devcontainer en un servidor remoto

Desde el fichero `./.vscode/settings.json` debemos modificar el host, también debemos tener configurado la clave pública en el servidor. Debe estar configurado el agente SSH.

```json
"docker.environment": {
    "DOCKER_HOST": "ssh://your-remote-user@your-remote-machine-or-ip-here"
}
```

---

### Variables de entorno

```bash
# GUARDAR ENV EN WINDOWS
[System.Environment]::SetEnvironmentVariable("TALLER_TOKEN", "mi_token_personal".Trim(), "User")
# OBTENER ENV EN WINDOWS
[System.Environment]::GetEnvironmentVariable("TALLER_TOKEN", "User")
```

```bash
# GUARDAR ENV EN Linux
export TALLER_TOKEN=mi_token_personal
# OBTENER ENV EN Linux
echo $TALLER_TOKEN
```

---

## OLLAMA

Ollama es un gestor de modelos LLM que permite descargar, ejecutar y desplegar modelo LLM fácilmente mediante un servidor que distribuye una [API](https://github.com/ollama/ollama/blob/main/docs/api.md).

Esta tecnología nos permite simplificar la distribución de modelos para distintos usos.

![OLLAMA](./assets/ollama.png)

---

## Open WebUI

Open-WebUI es una interfaz web de código abierto para interactuar con modelos de inteligencia artificial locales y en la nube. Suelen usarse con modelos LLM como Llama, Mistral o GPT a través de servidores como Ollama o LM Studio.

[@open-webui/open-webui](https://github.com/open-webui/open-webui)

[openwebui.com](https://openwebui.com/)

---

![Open WebUI](./assets/open-webui.png)

---

### Ejemplo de docker compose de un chat-gpt propio

```yaml
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: ${PROJECT_NAME}_open-webui
    restart: unless-stopped
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
```

---

```yml
  ollama:
    image: ollama/ollama:latest
    container_name: ${PROJECT_NAME}_ollama
    restart: unless-stopped
    tty: true
    volumes:
      - local-ollama:/root/.ollama
    pull_policy: always
    # GPU support
    runtime: nvidia
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

---

## Traefik

![](./assets/traefik.png)

---

### 🔹 Características principales:

- ✅ **Soporte para múltiples backends**: Docker, Kubernetes, entre otros.
- ✅ **SSL/TLS automatizado**: Let's Encrypt para generar y renovar certificados automáticamente.
- ✅ **Balanceo de carga**: Distribuye tráfico entre múltiples instancias de un servicio.
- ✅ **Dashboard y métricas**: Ofrece una interfaz para monitorear el tráfico y estadísticas.
- ✅ **Plugins**: Ofrece una gran cantidad de plugins que permite personalizar los routers.
- ✅ **Middleware personalizable**: Permite modificar peticiones y respuestas con reglas como redirecciones, autenticación, rate-limiting, etc.

---

En traefik solo tenemos 2 ficheros de configuraciópn, uno estatico que está asociado a la configuración de traefik y uno dinámico asociado a la configuración de los servicios.

- docker-compose.yml
- Config/traefik-static.yml
- Config/traefik-dynamic.yml

---

### docker-compose.yml

```yaml
  traefik:
    container_name: "${PROJECT_NAME}_traefik"
    image: traefik:v3.2
    restart: on-failure:1
    environment:
      TZ: ${TIMEZONE}
    ports:
      # Traefik
      - "8080:8080"
      # http(s)
      - "80:80"
      - "443:443"
      # Minecraft
      - "25565:25565/tcp"
    volumes:
      # Para que pueda controlar otros contenedores de docker
      - /var/run/docker.sock:/var/run/docker.sock:ro 
      # Configuración
      - ./Config/traefik-static.yml:/etc/traefik/traefik.yml:ro
      - ./Config/traefik-dynamic.yml:/etc/traefik/dynamic.yml:ro
      - ./Config/certs:/etc/certs:ro        
    networks:
      - proxy
      - backend
    labels:
      - traefik.http.routers.${PROJECT_NAME}_traefik.tls=true
      - traefik.http.routers.${PROJECT_NAME}_traefik.entrypoints=traefik
      - traefik.http.routers.${PROJECT_NAME}_traefik.service=api@internal
```

---

### traefik-static.yml

Se trata de configuración fija de traefik.

```yaml
global:       # Rules v2
api:          # traefik info
experimental: # Plugins
# Providers
providers:    # Docker, kubernets, etc...
# Features
log:        
accessLog:
metrics:      # OPEN TELEMETRICS
tracing:      # OPEN TELEMETRICS

entryPoints:

# etc...

```

---

### EntryPoints traefik-static.yml

Representan un puerto y puede ser tcp, udp o http(s), este se redirige desde traefik a los distintos servicios.

```yaml
entryPoints:
  traefik:
    address: ":8080"
    # ...
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
  websecure:
    address: ":443"
  minecraft:
    address: ":25565"
```

---

### Ejemplo de servicio en traefik

Añadimos al `docker-compose.yml` el servicio de docker.

```yaml
services:
  # ...
  traefik_whoami:
    image: traefik/whoami
    container_name: "${PROJECT_NAME}_traefik_whoami"
    security_opt:
      - no-new-privileges:true
    networks:
      - backend
      - proxy
    labels:
      - traefik.enable=true
```

---

### traefik-dynamic.yml

Añadimos al fichero de configuración dinámica de traefik (`traefik-dynamic.yml`) el _router_, el _service_ y los _middlewares_. Este fichero se actualiza de forma dinámica.

```yaml
http:
  # ======================================
  # Middlewares
  # ======================================
  middlewares:
    waf-modsecurity:
      plugin:
        plugin-traefik-modsecurity:
          maxBodySize: 10485760
          modSecurityUrl: "http://traefik_waf:8080"
        
    secure-public:
      chain:
        middlewares:
          - waf-modsecurity # Plugin
          # - <<<<middleware>>>>
```

---

```yaml
  # ======================================
  # Routers
  # ======================================
  routers:
    whoami:
      rule: "Host(`whoami.nonodev96.dev`)"
      entryPoints:
        - websecure
      middlewares:
        - secure-public@file
      service: "whoami-svc"
      tls: {}
```

---

```yaml
  # ======================================
  # Services
  # ======================================
  services:
    whoami-svc:
      loadBalancer:
        servers:
          # protocolo + nombre del servicio de docker compose + puerto interno
          - url: "http://traefik_whoami:80" 
```

---

### Hosts para traefik si no tenemos DNS

Para traefik debemos añadir la redirección al servicio, con ubuntu/debian `sudo nano /etc/hosts` y para Windows abrir el fichero `C:\Windows\System32\drivers\etc\hosts` con el editor de texto dando permisos de administrador y añadir los siguientes DNS.

```bash
# Añadimos el host
127.0.0.1 traefik.nonodev96.dev
127.0.0.1 whoami.nonodev96.dev
127.0.0.1 uptime.nonodev96.dev
127.0.0.1 photoprism.nonodev96.dev
# plugins
127.0.0.1 traefik-github-oauth.nonodev96.dev # Tarea por si te interesa

# Haremos este en el taller
127.0.0.1 chat.nonodev96.dev 
```

---

### Certificados

```bash
# Debian / Ubuntu
sudo apt install mkcert
# PowerShell Windows admin
choco install mkcert

# Ejecutar como administrador
mkcert -install
mkcert -cert-file Config/certs/taller-cert.pem 
       -key-file Config/certs/taller-key.pem "nonodev96.dev" "*.nonodev96.dev"
```

---

### Despliegue

```bash
docker compose down [servicio];
docker compose up -d [servicio];
```

```bash
docker compose down;
docker compose up -d;
```

---

## Referencias

- [CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit)
  - [CUDA GUIDE Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)
  - [CUDA GUIDE Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
  - [cuDNN](https://developer.nvidia.com/cudnn), [cuBLAS](https://developer.nvidia.com/cublas), [cuSPARSE](https://developer.nvidia.com/cusparse)
  - [Catálogo de contenedores de NVIDIA](https://catalog.ngc.nvidia.com/)
- [VSCODE Extensión Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [OLLAMA](https://ollama.com/), [OPEN WEB UI](https://docs.openwebui.com/)
- [Traefik](https://doc.traefik.io/traefik/v3.2/)

---

## Consideraciones en Windows

Puedes tener distintos docker en windows, asegúrate de estar usando el adecuado, pues la imágenes ocuparan mucha memoria

```bash
C:\Users\nono_>wsl.exe --list
Distribuciones de subsistema de Windows para Linux:
Ubuntu (predeterminado)
Ubuntu-24.04
docker-desktop # <-- Puedes desactivarlo, pero pierdes el puente del runtime
```

```bash
C:\Users\nono_>wsl.exe --shutdown
```