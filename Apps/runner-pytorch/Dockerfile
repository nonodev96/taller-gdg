# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

FROM nvcr.io/nvidia/pytorch:25.01-py3

# xx.xx es la versión del contenedor. Por ejemplo: 22.01 (año y mes).
# py3 es la versión de python 3
# igpu indica que es la gráfica integrada

WORKDIR /workspace

RUN pip install --upgrade pip

RUN apt update

RUN apt install screen -y