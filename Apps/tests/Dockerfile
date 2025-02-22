FROM ubuntu:22.04

# Espacio de trabajo donde se iniciará el contenedor una vez creada la imagen
WORKDIR /workspace_nonodev96

# Ejemplo de comando para la creación de la imagen
RUN apt update
RUN apt install screen -y

# Ejemplo de ENTRYPOINT con CMD
# Por defecto ENTRYPOINT es `/bin/sh -c`
ENTRYPOINT ["/bin/bash", "-c"]
# Proporciona valores por defecto para un contenedor ejecutable. 
# Si no se especifica un ejecutable, también debe especificarse ENTRYPOINT.
# Solo puede haber una instrucción CMD en un Dockerfile.
CMD ["echo 'hello world!' >> /workspace_nonodev96/hello_world.txt"]