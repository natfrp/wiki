#!/bin/bash
## bash only

set -e # We strict the whole script

CONFIG_BASE="/etc/natfrp"
LOW_USER="natfrp"

# Check root permission
if [ "$EUID" -ne 0 ]; then
    log_E "请使用 root 用户运行此脚本"
    exit 1
fi

# Utility functions
log_I() { echo -e "\e[32m[+] $1\e[0m"; }
log_W() { echo -e "\e[33m[!] $1\e[0m"; }
log_E() { echo -e "\e[31m[-] $1\e[0m"; }

ask_for_creds() {
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

check_executable() {
    version=$(sudo -H -u ${LOW_USER} $1 -v) || (
        log_E "无法获取 $1 版本信息, 文件可能已损坏, 请尝试再次执行脚本重新下载"
        exit 1
    )
    log_I "$1 版本: $version"
}

press_enter() {
    read -p "按 Enter 键以继续, 或 Ctrl-C 取消..."
}

# docker install should be the default
docker_install() {
    echo -e "\e[96m[*] Docker 已安装, 将使用 Docker 安装模式\e[0m
  - 将在您的系统上创建名为 natfrp-service 的容器
  - 将为您创建 ${CONFIG_BASE} 文件夹用于存储启动器配置文件\n"
    ask_for_creds

    mkdir -p ${CONFIG_BASE} || log_W "无法创建 ${CONFIG_BASE} 文件夹, 配置可能无法在容器重启后正常保存"

    if docker ps -a --format '{{.Names}}' | grep -q '^natfrp-service$'; then
        log_W "已存在名为 natfrp-service 的容器"
        read -p " - 是否移除已存在的容器? [y/N] " -r choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            docker kill natfrp-service || log_W "无法停止 natfrp-service 容器, 将尝试直接移除"
            docker rm natfrp-service
        else
            log_E "请手动移除已存在的容器后重新运行脚本"
            exit 1
        fi
    fi

    docker run -d --network=host --restart=on-failure:5 --pull=always --name=natfrp-service -v ${CONFIG_BASE}:/run -e "NATFRP_TOKEN=$api_key" -e "NATFRP_REMOTE=$remote_pass" -e "TZ=${TZ:-Asia/Shanghai}" natfrp.com/launcher || \
    (
        log_E "Docker 模式安装失败, 请检查 Docker 在是否正常运行以及是否能正常访问 natfrp.com 拉取镜像"
        exit 1
    )

    echo -e "\n\e[96mDocker 模式安装成功, 您可使用下面的命令管理服务:\e[0m
  - 查看日志\tdocker logs natfrp-service
  - 停止服务\tdocker stop natfrp-service
  - 启动服务\tdocker start natfrp-service
\n请登录远程管理界面启动隧道: https://www.natfrp.com/remote/v2\n"

    log_I "下方将输出启动器日志, 如需退出请按 Ctrl+C"
    docker logs -f natfrp-service

    exit 0
}

# install all files, should be run before any other bareinstall_ functions
bareinstall_base() {
    # Create user
    if ! id -u ${LOW_USER} &>/dev/null; then
        log_I "正在创建 ${LOW_USER} 用户"
        useradd -r -m -s /sbin/nologin ${LOW_USER}
    else
        echo -e "\e[32m[*] ${LOW_USER} 用户已存在\e[0m"
    fi

    # Download binaries
    cd /home/${LOW_USER}
    if [[ $? -ne 0 ]]; then
        log_E "无法切换到 /home/${LOW_USER} 目录"
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
        chown ${LOW_USER}: frpc natfrp-service
    fi

    # Make sure binaries can be executed
    check_executable "./frpc"
    check_executable "./natfrp-service"

    # Update config file
    mkdir -p ${CONFIG_BASE} || log_W "无法创建 ${CONFIG_BASE} 文件夹, 配置文件夹可能已存在, 我们将尝试迁移"

    config_file="${CONFIG_BASE}/config.json"
    if [[ -f $config_file ]]; then
        log_W "已存在 SakuraFrp 启动器配置文件"
        read -p " - 是否清空设置? 这可能有助于修复问题: [y/N] " -r choice

        if [[ $choice =~ ^[Yy]$ ]]; then
            rm -f $config_file
        fi
    fi

    if [[ ! -f $config_file ]]; then
        echo '{}' > $config_file
    fi

    jq ". + {
        "token": $(echo $api_key | jq -R .),
        "remote_management": true,
        "remote_management_key": $(./natfrp-service remote-kdf "$remote_pass" | jq -R .),
        "log_stdout": true
    }" $config_file >$config_file.tmp
    mv $config_file.tmp $config_file

    chown -R ${LOW_USER}: ${CONFIG_BASE}
}

bareinstall_systemd() {
    bareinstall_base

    # Stop existing service to avoid conflicts
    systemctl stop natfrp.service &>/dev/null ||:

    # Install systemd unit
    log_I "正在安装 systemd 服务"
    cat >"/etc/systemd/system/natfrp.service" <<EOF
[Unit]
Description=SakuraFrp Launcher
After=network.target

[Service]
User=${LOW_USER}
Group=${LOW_USER}

Type=simple
TimeoutStopSec=20

Restart=always
RestartSec=5s

Environment="NATFRP_SERVICE_WD=${CONFIG_BASE}"
ExecStart=/home/${LOW_USER}/natfrp-service --daemon

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload

     # Start service
    systemctl enable --now natfrp.service

    echo -e "\n\e[96mSakuraFrp 启动器安装完成, 您可使用下面的命令管理服务: \e[0m
  - 查看状态\tsystemctl status natfrp.service
  - 停止服务\tsystemctl stop natfrp.service
  - 启动服务\tsystemctl start natfrp.service
  - 查看日志\tjournalctl -u natfrp.service
\n请登录远程管理界面启动隧道: https://www.natfrp.com/remote/v2\n"

    log_I "下方将输出启动器日志, 如需退出请按 Ctrl+C"
    journalctl -u natfrp.service -f
}

bareinstall_other() {
    bareinstall_base

    # Write a start script to /home/${LOW_USER}/start.sh
    cat >/home/${LOW_USER}/start.sh <<EOF
#!/bin/bash
cd /home/${LOW_USER}
sudo -H -u ${LOW_USER} "NATFRP_SERVICE_WD=${CONFIG_BASE}" ./natfrp-service --daemon
EOF
    chmod +x /home/${LOW_USER}/start.sh

    echo -e "\n\e[96mSakuraFrp 启动器文件安装完成, 您可以运行 bash /home/${LOW_USER}/start.sh 临时启动服务, 或配置到您喜爱的服务管理器中\e[0m"
}

uninstall() {
    set +e
    read -p " - 确认要卸载 SakuraFrp 启动器吗? [y/N] " -r choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        if docker ps -a --format '{{.Names}}' | grep -q '^natfrp-service$'; then
            docker kill natfrp-service &>/dev/null || log_W "无法停止 natfrp-service 容器, 将尝试直接删除"
            docker rm natfrp-service &>/dev/null && log_I "已删除 Docker 容器"
        fi

        if [[ -f /etc/systemd/system/natfrp.service ]]; then
            systemctl stop natfrp.service &>/dev/null
            systemctl disable natfrp.service &>/dev/null
            rm -f /etc/systemd/system/natfrp.service &>/dev/null && log_I "已删除 systemd 服务"
            systemctl reload-daemon &>/dev/null
        fi

        if [[ -d /home/${LOW_USER}/natfrp-service ]]; then
            rm -rf /home/${LOW_USER}/frpc /home/${LOW_USER}/natfrp-service &>/dev/null && log_I "已删除 /home/${LOW_USER} 中的程序文件"
        fi

        if id -u ${LOW_USER} &>/dev/null; then
            userdel ${LOW_USER} &>/dev/null && log_I "已删除 ${LOW_USER} 账户"
        fi

        read -p " - 是否删除启动器数据 (包括登录信息、日志等)? [y/N] " -r choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            if [[ -d /home/${LOW_USER} ]]; then
                rm -rf /home/${LOW_USER} &>/dev/null && log_I "已删除 /home/${LOW_USER} 中的启动器数据"
            fi
            if [[ -d ${CONFIG_BASE} ]]; then
                rm -rf ${CONFIG_BASE} &>/dev/null && log_I "已删除 ${CONFIG_BASE} 中的启动器数据"
            fi
        else
            log_I "启动器数据未删除, 您可再次执行卸载脚本以删除"
        fi
        log_I "SakuraFrp 启动器已成功卸载"
    else
        log_I "SakuraFrp 启动器未被卸载"
    fi
}

######### Main script start #########

if [[ $1 == "uninstall" ]]; then
    uninstall
    exit 0
fi

# Use docker if available
if docker info &>/dev/null && [[ $1 != "direct" ]]; then
    docker_install
    exit 0
fi

log_W "您正在使用非 Docker 安装模式"
echo "我们建议您总是使用 Docker 安装模式, 以便于管理和减少兼容性问题"

# Check SELinux
if command -v getenforce &>/dev/null; then
    if [[ $(getenforce) == "Enforcing" ]]; then
        log_E "SELinux 处于启用状态, 为避免出现问题, 请安装 Docker 后重新运行脚本以使用 Docker 部署"
        exit 1
    fi
fi

# Install deps
required_tools=(curl jq zstd sudo)
missing_tools=()
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        missing_tools+=("$tool")
    fi
done
if [[ ${#missing_tools[@]} -ne 0 ]]; then
    log_I "正在使用包管理器安装必要的工具程序: ${missing_tools[*]}"
    if command -v apt-get &>/dev/null; then
        apt-get update && apt-get install -y "${missing_tools[@]}"
    elif command -v yum &>/dev/null; then
        yum install -y "${missing_tools[@]}"
    elif command -v zypper &>/dev/null; then
        zypper install -y "${missing_tools[@]}"
    elif command -v opkg &>/dev/null; then
        opkg update && opkg install "${missing_tools[@]}"
    elif command -v apk &>/dev/null; then
        apk --update add "${missing_tools[@]}"
    else
        log_E "当前系统的包管理器暂时不受支持, 请手动安装 ${missing_tools[*]} 后重新运行脚本"
        exit 1
    fi
fi

# Migrate config files from old script
if [[ -f "/home/natfrp/.config/natfrp-service/config.json" && ${CONFIG_BASE} != "/home/natfrp/.config/natfrp-service" ]]; then
    log_W "检测到旧的配置文件, 将为您迁移到 ${CONFIG_BASE} 目录"
    read -p " - 是否迁移配置文件? [y/N] " -r choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        systemctl stop natfrp.service &>/dev/null || log_W "无法停止旧服务, 将尝试直接迁移"
        mkdir -p ${CONFIG_BASE} || log_W "无法创建 ${CONFIG_BASE} 文件夹, 配置文件夹可能已存在, 我们将尝试迁移"
        mv -f /home/natfrp/.config/natfrp-service/ ${CONFIG_BASE}/ || log_W "无法完整迁移旧配置文件, 数据迁移可能不完整"
        chown -R ${LOW_USER}: ${CONFIG_BASE}
        log_I "已迁移旧配置文件到 ${CONFIG_BASE} 目录"
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

ask_for_creds

# Check init
ls -l /proc/1/exe | grep -q systemd && is_systemd=1 || is_systemd=0

if [ $is_systemd -eq 1 ]; then
    echo -e "\e[96m[*] 将使用 systemd 安装模式\e[0m
  - 将在您的系统上创建名为 ${LOW_USER} 的用户
  - 将在 /home/${LOW_USER} 目录下保存 SakuraFrp 启动器文件
  - 将为您创建 ${CONFIG_BASE} 文件夹用于存储启动器配置文件
  - 将创建 systemd 服务并启动 SakuraFrp 启动器\n"
    press_enter
    bareinstall_systemd
else
    echo -e "\e[96m[*] 未发现 systemd, 将只安装启动器文件\e[0m
  - 将在您的系统上创建名为 ${LOW_USER} 的用户
  - 将在 /home/${LOW_USER} 目录下保存 SakuraFrp 启动器文件
  - 将为您创建 ${CONFIG_BASE} 文件夹用于存储启动器配置文件
  - 将在 /home/${LOW_USER}/start.sh 创建一个脚本用于运行 SakuraFrp 启动器
  \e[31m- 需手动启动, 不会开机自启
  - 关闭后不会自动重启\e[0m\n"
    press_enter
    bareinstall_other
fi