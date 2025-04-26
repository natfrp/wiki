#!/bin/bash

set -e

# ---------------- 日志函数 ----------------
log_I() { echo -e "\e[32m[+] $1\e[0m"; }
log_W() { echo -e "\e[33m[!] $1\e[0m"; }
log_E() { echo -e "\e[31m[-] $1\e[0m"; }

# ---------------- 权限检查 ----------------
check_privilage() {
    if [[ "$EUID" -ne 0 ]]; then
        log_E "请使用 root 用户运行此脚本"
        exit 1
    fi
}

# ---------------- systemd 检查 ----------------
check_systemd() {
    if ! command -v systemctl &>/dev/null || [[ ! -d /run/systemd/system/ ]]; then
        log_W "系统未启用 systemd, 将使用非 systemd 模式"
        USE_SYSTEMD=false
    else
        USE_SYSTEMD=true
    fi
}

# ---------------- 架构识别 ----------------
check_architecture() {
    case $(uname -m) in
        x86_64) ARCH=amd64 ;;
        i386) ARCH=386 ;;
        aarch64) ARCH=arm64 ;;
        armv7l) ARCH=armv7 ;;
        mips) ARCH=mips ;;
        mipsel) ARCH=mipsle ;;
        mips64) ARCH=mips64 ;;
        mips64le) ARCH=mips64le ;;
        riscv64) ARCH=riscv64 ;;
        loongarch64) ARCH=loong64 ;;
        *) log_E "不支持当前系统架构: $(uname -m)"; exit 1 ;;
    esac
}

# ---------------- 安装依赖 ----------------
install_prerequisites() {
    echo -e "${blue}检查并安装必需的依赖...${none}"
    if command -v lsb_release &>/dev/null; then
        os_name=$(lsb_release -si | tr '[:upper:]' '[:lower:]')  # 转换为小写
        case $os_name in
            ubuntu|debian)
                pkg_manager="apt-get update && apt-get install -y "
                ;;
            centos|fedora|rhel)
                if command -v dnf &>/dev/null; then
                    pkg_manager="dnf install -y "
                else
                    pkg_manager="yum install -y "
                fi
                ;;
            opensuse*)
                pkg_manager="zypper install -y "
                ;;
            openwrt)
                pkg_manager="opkg update && opkg install "
                ;;
            alpine)
                pkg_manager="apk --update add "
                ;;
            *)
                pkg_manager=
                ;;
        esac
    # 如果 lsb_release 不可用，回退到 /etc/os-release
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release  # 加载 os-release 文件中的变量
        os_name=${ID,,}    # 获取 ID 并转换为小写
        case $os_name in
            ubuntu|debian)
                pkg_manager="apt-get update && apt-get install -y "
                ;;
            centos|fedora|rhel)
                if command -v dnf &>/dev/null; then
                    pkg_manager="dnf install -y "
                else
                    pkg_manager="yum install -y "
                fi
                ;;
            opensuse*)
                pkg_manager="zypper install -y "
                ;;
            openwrt)
                pkg_manager="opkg update && opkg install "
                ;;
            alpine)
                pkg_manager="apk --update add "
                ;;
            *)
                pkg_manager=
                ;;
        esac
    fi
    for cmd in curl tar jq; do
        if ! command -v $cmd >/dev/null 2>&1; then
            if [[ -n "$pkg_manager" ]]; then
                $pkg_manager $cmd
            else
                echo -e "${red}缺少依赖 ${cmd}，请手动安装。${none}"
                exit 1
            fi
        fi
    done
    if ! command -v zstd >/dev/null 2>&1; then
        if [[ -n "$pkg_manager" ]]; then
            $pkg_manager zstd
        else
            echo -e "${red}缺少 zstd，请手动安装。${none}"
            exit 1
        fi
    fi
}

# ---------------- 用户输入凭据 ----------------
ask_for_creds() {
    while true; do
        read -e -s -p "请输入 SakuraFrp 的访问密钥: " api_key
        echo
        api_key_respond=$(curl -LI -X 'GET' "https://api.natfrp.com/v4/user/info?token=${api_key}" -o /dev/null -w '%{http_code}\n' -s)
        echo ${api_key_respond}
        if  [[ ${api_key_respond} -eq 200 ]]; then break; fi
        log_E "访问密钥错误"
    done

    while true; do
        while true; do
            read -e -s -p "请输入远程管理密码（至少八个字符）: " remote_pass
            echo
            if [[ ${#remote_pass} -ge 8 ]]; then break; fi
            log_E "远程管理密码至少需要 8 字符"
        done

        read -e -s -p "请再次输入远程管理密码: " remote_pass_confirm
        echo
        if [[ "$remote_pass" == "$remote_pass_confirm" ]]; then break; fi
        log_E "两次输入的远程管理密码不一致"
    done
}

# ---------------- 二进制安装相关 ----------------
create_user() {
    if ! id -u natfrp &>/dev/null; then
        useradd -r -m -s /sbin/nologin natfrp
        log_I "创建用户 natfrp"
    else
        log_W "natfrp 用户已存在"
    fi
}

download_binary() {
    mkdir -p /usr/local/bin && cd /usr/local/bin
    if [[ -f frpc || -f natfrp-service ]]; then
        log_W "已有启动器文件"
        read -p "是否重新下载？[y/N] " choice
        [[ $choice =~ ^[Yy]$ ]] && rm -f frpc natfrp-service
    fi

    log_I "正在下载 natfrp-service 二进制文件..."
    curl -Lo - "https://nya.globalslb.net/natfrp/client/launcher-unix/latest/natfrp-service_linux_${ARCH}.tar.zst" \
        | tar -xI zstd --overwrite
    chmod +x frpc natfrp-service
    chown natfrp: frpc natfrp-service
}

setup_config() {
    mkdir -p /etc/natfrp
    chown natfrp: /etc/natfrp
    config_file=/etc/natfrp/config.json

    remote_key=$(/usr/local/bin/natfrp-service remote-kdf "$remote_pass")

    cat > "$config_file" <<EOF
{
  "token": "$api_key",
  "remote_management": true,
  "remote_management_key": "$remote_key",
  "log_stdout": true
}
EOF
    chown natfrp: "$config_file"
}

install_systemd_service() {
    cat > "/etc/systemd/system/natfrp.service" <<EOF
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
ExecStart=/usr/local/bin/natfrp-service --daemon -c /etc/natfrp

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable natfrp.service
    systemctl start natfrp.service
}

start_without_systemd() {
    log_I "使用非 systemd 模式启动"
    /usr/local/bin/natfrp-service --daemon -c /etc/natfrp &
    echo $! > /var/run/natfrp.pid
    log_I "已在后台启动，PID: $(cat /var/run/natfrp.pid)"
}

# ---------------- Docker 安装 ----------------
install_docker_mode() {
    log_I "Docker 安装模式选择"
    echo "请选择镜像来源："
    echo "1. 官方 (natfrp.com/launcher)"
    echo "2. GitHub (ghcr.io/natfrp/launcher)"
    echo "3. Docker Hub (natfrp/launcher)"
    read -p "请输入选项 [1-3] (默认1): " source
    case $source in
        2) image="ghcr.io/natfrp/launcher" ;;
        3) image="natfrp/launcher" ;;
        *) image="natfrp.com/launcher" ;;
    esac

    ask_for_creds

    if docker ps -a --format '{{.Names}}' | grep -q '^natfrp$'; then
        log_W "已存在名为 natfrp 的容器"
        read -p " - 是否移除已存在的容器? [y/N] " -r choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            docker kill natfrp 2>/dev/null
            docker rm natfrp 2>/dev/null
        else
            log_E "请手动移除已存在的容器后重新运行脚本"
            exit 1
        fi
    fi

    docker run -d \
        --network=host \
        --restart always \
        --name natfrp \
        --pull=always \
        -v /etc/natfrp:/run \
        -e TOKEN="$api_key" \
        -e REMOTE_PASS="$remote_pass" \
        $image
}

# ---------------- 卸载功能 ----------------
uninstall_natfrp() {
    echo "卸载 natfrp..."
    if docker ps -a --format '{{.Names}}' | grep -q '^natfrp$'; then
	docker stop natfrp || docker kill natfrp 2>/dev/null
	docker rm natfrp 2>/dev/null
    else
    	systemctl stop natfrp.service 2>/dev/null || true
    	systemctl disable natfrp.service 2>/dev/null || true
    	rm -f /etc/systemd/system/natfrp.service
    	rm -f /usr/local/bin/frpc /usr/local/bin/natfrp-service
    	userdel -r natfrp 2>/dev/null || true
    	systemctl daemon-reexec
    fi
    rm -rf /etc/natfrp
    log_I "natfrp 卸载完成"
    exit 0
}

# ---------------- 主流程 ----------------
MODE="binary"

for arg in "$@"; do
    case $arg in
        --docker) MODE="docker" ;;
        --uninstall) uninstall_natfrp ;;
    esac
    shift
done

check_privilage
check_architecture
check_systemd

if [[ "$MODE" == "docker" ]]; then
    install_docker_mode
else
    ask_for_creds
    create_user
    download_binary
    setup_config
    if [[ "$USE_SYSTEMD" == true ]]; then
        install_systemd_service
    else
        start_without_systemd
    fi
fi

log_I "natfrp 安装完成！"
log_I "登录面板管理: https://www.natfrp.com/remote/v2"
