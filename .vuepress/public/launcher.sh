#!/bin/bash

function log_I {
    echo -e "\e[32m[+] $1\e[0m"
}

function log_W {
    echo -e "\e[33m[!] $1\e[0m"
}

function log_E {
    echo -e "\e[31m[-] $1\e[0m"
}

function ask_for_creds {
    read -e -p "请输入 SakuraFrp 的 访问密钥: " api_key
    if [[ ${#api_key} -lt 16 ]]; then
        log_E "访问密钥至少需要 16 字符, 请从管理面板直接复制粘贴"
        exit 1
    fi

    read -e -p "请输入您希望使用的远程管理密码 (至少八个字符): " remote_pass
    if [[ ${#remote_pass} -lt 8 ]]; then
        log_E "远程管理密码至少需要 8 字符"
        exit 1
    fi

    read -e -p "请再次输入远程管理密码: " remote_pass_confirm
    if [[ $remote_pass != $remote_pass_confirm ]]; then
        log_E "两次输入的远程管理密码不一致, 请确认知晓自己正在输入的内容"
        exit 1
    fi
}

function check_executable {
    version=$(sudo -u natfrp $1 -v)
    if [[ $? -ne 0 ]]; then
        log_E "无法正常执行二进制文件 $1"
        exit 1
    fi
    log_I "$1 版本: $version"
}

set -e

# Check root permission
if [ "$EUID" -ne 0 ]; then
    log_E "请使用 root 用户运行此脚本"
    exit 1
fi

if command -v docker &>/dev/null && [[ $1 != "direct" ]]; then
    echo -e "\e[96m[*] Docker 已安装, 将使用 Docker 安装模式\e[0m\n  - 将在您的系统上创建名为 natfrp-service 的容器\n  - 将为您创建 /etc/natfrp 文件夹用于存储启动器配置文件\n"
    ask_for_creds

    mkdir -p /etc/natfrp || log_W "无法创建 /etc/natfrp 文件夹, 配置可能无法在容器重启后正常保存"

    if docker ps -a --format '{{.Names}}' | grep -q '^natfrp-service$'; then
        log_W "已存在名为 natfrp-service 的容器"
        read -p " - 是否移除已存在的容器? [y/N] " -r choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            docker kill natfrp-service
            docker rm natfrp-service
        else
            log_E "请手动移除已存在的容器后重新运行脚本"
            exit 1
        fi
    fi

    docker run -d --network=host --restart=on-failure:5 --pull=always --name=natfrp-service -v /etc/natfrp:/run -e "NATFRP_TOKEN=$api_key" -e "NATFRP_REMOTE=$remote_pass" natfrp.com/launcher
    if [[ $? -ne 0 ]]; then
        log_E "Docker 模式安装失败, 请检查 Docker 在是否正常运行以及是否能正常访问 natfrp.com 拉取镜像"
        exit 1
    fi

    echo -e "\n\e[96mDocker 模式安装成功, 您可使用下面的命令管理服务:\e[0m\n  - 查看日志\tdocker logs natfrp-service\n  - 停止服务\tdocker stop natfrp-service\n  - 启动服务\tdocker start natfrp-service\n\n请登录远程管理界面启动隧道: https://www.natfrp.com/remote/v2\n"

    log_I "下方将输出启动器日志, 如需退出请按 Ctrl+C"
    docker logs -f natfrp-service

    exit 0
fi

# Check systemd
if ! command -v systemctl &>/dev/null; then
    log_E "您的系统没有安装 systemd, 请安装 Docker 后重新运行脚本"
    exit 1
fi
if [[ ! -d /run/systemd/system/ ]]; then
    log_E "您的系统并未由 systemd 管理, 请安装 Docker 后重新运行脚本"
    exit 1
fi

# Check SELinux
if command -v getenforce &>/dev/null; then
    if [[ $(getenforce) == "Enforcing" ]]; then
        log_E "SELinux 处于启用状态, 为避免出现问题, 请安装 Docker 后重新运行脚本"
        exit 1
    fi
fi

echo -e "\e[96m[*] Docker 未安装, 将使用常规安装模式\e[0m\n  - 将在您的系统上创建名为 natfrp 的用户\n  - 将在 /home/natfrp 目录下安装 SakuraFrp 启动器\n  - 将创建 systemd 服务并启动 SakuraFrp 启动器\n"
ask_for_creds

if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null || ! command -v zstd &>/dev/null; then
    log_I "正在安装脚本运行所需的工具 curl jq zstd"

    if command -v apt-get &>/dev/null; then
        apt-get update && apt-get install -y curl jq zstd
    elif command -v yum &>/dev/null; then
        yum install -y curl jq zstd
    elif command -v zypper &>/dev/null; then
        zypper install -y curl jq zstd
    elif command -v opkg &>/dev/null; then
        opkg update && opkg install curl jq zstd
    elif command -v apk &>/dev/null; then
        apk --update add curl jq zstd
    else
        log_E "当前系统的包管理器暂时不受支持, 请手动安装 curl jq zstd 后重新运行脚本"
        exit 1
    fi
fi

# Determine filename
case $(uname -m) in
"x86_64") arch="amd64" ;;
"i386") arch="386" ;;
"aarch64") arch="arm64" ;;
"armv7l") arch="armv7" ;;
"mips") arch="mips" ;;
"mipsel") arch="mipsle" ;;
"mips64") arch="mips64" ;;
"mips64le") arch="mips64le" ;;
"riscv64") arch="riscv64" ;;
"loongarch64") arch="loong64" ;;
*)
    log_E "不支持当前系统架构: $arch"
    exit 1
    ;;
esac

# Create user
if ! id -u natfrp &>/dev/null; then
    log_I "正在创建 natfrp 用户"
    useradd -r -m -s /sbin/nologin natfrp
else
    echo -e "\e[32m[*] natfrp 用户已存在\e[0m"
fi

# Download binaries
cd /home/natfrp
if [[ $? -ne 0 ]]; then
    log_E "无法切换到 /home/natfrp 目录"
    exit 1
fi

do_download=1
if [[ -f frpc && -f natfrp-service ]]; then
    log_W "已存在 SakuraFrp 启动器文件"
    read -p " - 是否删除已有的文件重新下载? [y/N] " -r choice

    if [[ $choice =~ ^[Yy]$ ]]; then
        rm -f frpc natfrp-service
    else
        do_download=0
    fi
fi

if [[ $do_download == 1 ]]; then
    log_I "正在下载启动器..."
    curl -Lo - "https://nya.globalslb.net/natfrp/client/launcher-unix/latest/natfrp-service_linux_$arch.tar.zst" |
        tar -xI zstd --overwrite
    chmod +x frpc natfrp-service
    chown natfrp: frpc natfrp-service
fi

# Make sure binaries can be executed
check_executable "./frpc"
check_executable "./natfrp-service"

# Stop existing service to avoid conflicts
systemctl stop natfrp.service &>/dev/null ||:

# Install systemd unit
log_I "正在安装 systemd Unit"
cat >"/etc/systemd/system/natfrp.service" <<EOF
[Unit]
Description=SakuraFrp Launcher
After=network.target

[Service]
User=natfrp
Group=natfrp

Type=simple
TimeoutStopSec=20

Restart=always
RestartSec=5s

ExecStart=/home/natfrp/natfrp-service --daemon

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload

# Update config file
config_file=/home/natfrp/.config/natfrp-service/config.json
if [[ -f $config_file ]]; then
    log_W "已存在 SakuraFrp 启动器配置文件"
    read -p " - 是否清空设置? 这可能有助于修复问题: [y/N] " -r choice

    if [[ $choice =~ ^[Yy]$ ]]; then
        rm -f $config_file
    fi
fi

if [[ ! -f $config_file ]]; then
    mkdir -p /home/natfrp/.config/natfrp-service
    touch $config_file
fi

jq ". + {
    "token": $(echo $api_key | jq -R),
    "remote_management": true,
    "remote_management_key": $(/home/natfrp/natfrp-service remote-kdf "$remote_pass" | jq -R),
    "log_stdout": true
}" $config_file >$config_file.tmp
mv $config_file.tmp $config_file

# Start service
systemctl enable natfrp.service
systemctl restart natfrp.service
systemctl status natfrp.service

echo -e "\n\e[96mSakuraFrp 启动器安装完成, 您可使用下面的命令管理服务: \e[0m\n  - 查看状态\tsystemctl status natfrp.service\n  - 停止服务\tsystemctl stop natfrp.service\n  - 启动服务\tsystemctl start natfrp.service\n  - 查看日志\tjournalctl -u natfrp.service\n\n请登录远程管理界面启动隧道: https://www.natfrp.com/remote/v2\n"

log_I "下方将输出启动器日志, 如需退出请按 Ctrl+C"
journalctl -u natfrp.service -f
