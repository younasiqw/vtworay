#!/bin/bash

# 判断是否为root用户
if [ $UID -ne 0 ]; then
    echo "Error: You must be root to run this script, please use root to install v2ray."
    exit 1
fi

# 获取系统发行版信息
if grep -Eq "Ubuntu" /etc/*-release; then
    OS="ubuntu"
elif grep -Eq "Debian" /etc/*-release; then
    OS="debian"
elif grep -Eq "CentOS" /etc/*-release; then
    OS="centos"
else
    echo "Error: This script only supports Ubuntu, Debian or CentOS."
    exit 1
fi

# 安装必要的依赖
if [ "$OS" == "ubuntu" ] || [ "$OS" == "debian" ]; then
    apt-get update && apt-get install curl jq -y
elif [ "$OS" == "centos" ]; then
    yum update && yum install curl jq -y
fi

# 获取v2ray最新版本号
VER=$(curl -s https://api.github.com/repos/v2fly/v2ray-core/releases/latest | jq -r ".tag_name")

# 根据系统架构确定下载链接
if [ "$(uname -m)" == "x86_64" ]; then
    URL="https://github.com/v2fly/v2ray-core/releases/download/$VER/v2ray-linux-64.zip"
elif [ "$(uname -m)" == "aarch64" ]; then
    URL="https://github.com/v2fly/v2ray-core/releases/download/$VER/v2ray-linux-arm64-v8a.zip"
else
    echo "Error: Unsupported system architecture."
    exit 1
fi

# 下载并解压v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray.zip $URL
unzip /tmp/v2ray.zip -d /usr/local/bin/

# 创建v2ray配置文件
cat > /etc/v2ray/config.json <<EOF
{
    "inbounds": [{
        "port": 443,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "$(cat /proc/sys/kernel/random/uuid)",
                "alterId": 64
            }]
        },
        "streamSettings": {
            "network": "tcp",
            "security": "none",
            "tcpSettings": {
                "header": {
                    "type": "http"
                }
            },
            "tlsSettings": {
                "allowInsecure": true
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom",
        "settings": {}
    }]
}
EOF

# 提示用户输入传输协议
read -p "Please select a transport protocol (default: tcp):" TRANSPORT
TRANSPORT=${TRANSPORT:-"tcp"}

# 根据用户选择修改配置文件
if [ "$TRANSPORT" == "tcp" ]; then
    sed -i 's/"streamSettings": {/"streamSettings": {\n        "network": "tcp",/' /etc/v2ray/config.json
elif [ "$TRANSPORT" == "mkcp" ]; then
    sed -i 's/"streamSettings": {/"streamSettings": {\n        "network": "mkcp",/' /etc/v2ray/config.json
fi

# 提示用户输入加密方式
read -p "Please select a encryption method (default: aes-128-gcm):" ENCRYPT
ENCRYPT=${ENCRYPT:-"aes-128-gcm"}

# 根据用户选择修改配置文件
if [ "$ENCRYPT" == "aes-128-gcm" ]; then
    sed -i 's/"security": "none"/"security": "'$ENCRYPT'"/' /etc/v2ray/config.json
elif [ "$ENCRYPT" == "chacha20-poly1305" ]; then
    sed -i 's/"security": "none"/"security": "'$ENCRYPT'"/' /etc/v2ray/config.json
fi

# 提示用户输入伪装方式
read -p "Please select a camouflage method (default: none):" CAMOUFLAGE
CAMOUFLAGE=${CAMOUFLAGE:-"none"}

# 根
