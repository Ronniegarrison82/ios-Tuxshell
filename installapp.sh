#!/bin/bash

set -e
set -u

echo "[+] Updating packages..."
apt update -y
apt upgrade -y

echo "[+] Installing core CLI tools and development packages..."

apt install -y \
build-essential \
curl \
wget \
git \
vim \
nano \
fish \
htop \
net-tools \
iputils-ping \
tcpdump \
python3 \
python3-pip \
python3-venv \
lsof \
software-properties-common \
screen \
tmux \
bash-completion \
man-db \
openssh-client \
unzip \
zip \
jq \
gcc \
g++ \
make \
automake \
autoconf \
pkg-config

echo "[+] Installing Python packages..."

pip3 install --upgrade pip setuptools wheel

echo "[+] Environment setup complete."
