# vtworay

vtworay 是一個基於 v"two"ray 的脚本，能夠快速搭建安全、稳定的代理服务器。

## 安装方式

使用以下命令进行安装：

```bash
bash <(wget -qO- https://raw.githubusercontent.com/younasiqw/vtworay/main/vtworayinstall.sh)
安装完成后，配置文件位于 /etc/v2ray/config.json，默认使用 TCP + AES-128-GCM 加密，无伪装。

配置修改
修改传输协议

在安装完成后，会提示修改传输协议，默认为 tcp，也可以选择 mkcp。

bash
Please select a transport protocol (default: tcp):
修改加密方式

在安装完成后，会提示修改加密方式，默认为 aes-128-gcm，也可以选择 chacha20-poly1305。

bash
Please select an encryption method (default: aes-128-gcm):
修改伪装方式

在安装完成后，会提示修改伪装方式，默认为不伪装，也可以选择 http 或 tls。

bash
Please select a camouflage method (default: none):
添加多个用户

如果您需要添加多个用户，可以手动编辑配置文件 /etc/v2ray/config.json，在 clients 字段下添加多个用户，每个用户需要指定 id 和 alterId。

json
{
    "inbounds": [{
        "port": 443,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "df7a38db-b0d6-4f37-ba1e-e1993f9b1c70",
                "alterId": 64
            }, {
                "id": "43c91995-6ee1-4749-a98a-6ce5b06bdb16",
                "alterId": 64
            }]
        },
        "streamSettings": {
            "network": "tcp",
            "security": "aes-128-gcm",
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
其他功能
本脚本还提供了以下额外的功能：

查看 v2ray 运行状态：systemctl status v2ray

停止 v2ray：systemctl stop v2ray

启动 v2ray：systemctl start v2ray

重启 v2ray：systemctl restart v2ray

卸载 vtworay：bash <(wget -qO- https://raw.githubusercontent.com/younasiqw/vtworay/main/vtworayuninstall.sh)
