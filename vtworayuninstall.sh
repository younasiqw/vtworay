#!/bin/bash

# 判断是否为root用户
if [ $UID -ne 0 ]; then
    echo "Error: You must be root to run this script, please use root to uninstall v2ray."
    exit 1
fi

# 停止v2ray服务并删除配置文件
systemctl stop v2ray
rm -rf /etc/v2ray

# 删除v2ray二进制文件和systemd配置文件
rm -f /usr/local/bin/v2ray /usr/local/bin/v2ctl /etc/systemd/system/v2ray.service

# 删除日志文件和临时目录
rm -rf /var/log/v2ray /tmp/v2ray

echo "v2ray has been uninstalled."
