FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine

# === TAKEN FROM: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/blob/master/Dockerfile ===
# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# === TAKEN FROM: https://github.com/aldycool/python3-with-tools/blob/master/Dockerfile ===
# NOTE: ruamel.yaml is installed directly using alpine package: https://pkgs.alpinelinux.org/package/edge/community/x86_64/py3-ruamel.yaml
RUN pip3 install requests && \
    apk add --no-cache py3-ruamel.yaml --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk add curl && \
    rm -r /root/.cache
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

RUN apk add --no-cache openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk