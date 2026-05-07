FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /miner

RUN apt update && apt install --no-install-recommends -y \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    libcurl4-openssl-dev \
    libjansson-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN find . -type f -exec sed -i 's/\r$//' {} +

RUN ./autogen.sh \
    && ./configure \
    && make -j"$(nproc)"

CMD ["bash", "-c", "./ccminer -a ${ALG} -o ${POOL} -u ${MINER_USER} -p ${MINER_PASS}"]
