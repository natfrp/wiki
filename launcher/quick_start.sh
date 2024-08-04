#!/bin/bash

if command -v apk &> /dev/null; then
    echo -e "\e[31m检测到您使用Alpine,请自行手动安装,本脚本暂时不支持Alphine\033[0m"
    exit 1
fi

# 安装必要的工具
echo -e "\e[32m正在安装必要的工具\033[0m"
if command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y sudo wget jq zstd
elif command -v yum &> /dev/null; then
    yum install -y sudo wget jq zstd
else
    echo -e "\e[31m无法自动安装必要的工具 sudo wget jq zstd , 请自行手动安装。\033[0m"
    exit 1
fi

# 获取版本号
json_data=$(curl -s 'https://api.natfrp.com/v4/system/clients')
client_version=$(echo "$json_data" | jq -r '.unix.ver')
if [ ! -z "$client_version" ]; then
    echo "最新的Linux启动器版本为: $client_version"
else
    echo -e "\e[33m未能成功获取版本号，将使用内置版本号来安装\033[0m"
    client_version = "3.1.4"
    echo -e "内置的版本号为： $client_version"
fi

# 获取API密钥和远程管理密码
read -p "请输入SakuraFrp的API密钥: " api_key
read -p "请输入您希望使用的远程管理密码: " remote_pass 

# 获取系统架构
arch=$(uname -m)

case $arch in
    "x86_64") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_amd64.tar.zst";;
    "i386") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_386.tar.zst";;
    "aarch64") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_arm64.tar.zst";;
    "armv7l") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_armv7.tar.zst";;
    "mips") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_mips.tar.zst";;
    "mipsel") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_mipsle.tar.zst";;
    "mips64") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_mips64.tar.zst";;
    "mips64le") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_mips64le.tar.zst";;
    "riscv64") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_riscv64.tar.zst";;
    "loongarch64") arch_link="https://nya.globalslb.net/natfrp/client/launcher-unix/$client_version/natfrp-service_linux_loong64.tar.zst";;
    *) echo "不支持当前系统架构: $arch"; exit 1;;
esac

# 创建natfrp用户
echo -e "\e[32m正在创建natfrp用户\033[0m"
if ! id -u natfrp &> /dev/null; then
    sudo useradd -r -m -s /sbin/nologin natfrp
fi

# 下载并解压启动器
cd /home/natfrp || exit

echo -e "\e[32m正在下载启动器\033[0m"

sudo curl -L -O "$arch_link"

echo -e "\e[32m正在解压启动器\033[0m"
sudo zstd -d *.tar.zst
sudo tar -xvf *.tar
rm *.tar.zst

# 设置执行权限和所有者
sudo chmod +x frpc natfrp-service
sudo chown natfrp:natfrp frpc natfrp-service

# 创建Systemd Unit文件
echo -e "\e[32m创建service\033[0m"
unit_file="/etc/systemd/system/natfrp.service"

cat << EOF | sudo tee $unit_file
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

# 启动服务来生成配置文件
systemctl start natfrp.service
sleep 3
systemctl stop natfrp.service

# 生成并设置远程管理密码
remote_key=$(/home/natfrp/natfrp-service remote-kdf "$remote_pass")
remote_key=$(printf '%s\n' "$remote_key" | sed 's/[\/&]/\\&/g')
sed -i 's/"token": ".*"/"token": "'"$api_key"'"/' /home/natfrp/.config/natfrp-service/config.json
sed -i '/"remote_management":/ s/false/true/' /home/natfrp/.config/natfrp-service/config.json
sed -i 's/"remote_management_key": null/"remote_management_key": "'"$remote_key"'"/' /home/natfrp/.config/natfrp-service/config.json

# 启动并启用服务
sudo systemctl daemon-reload
sudo systemctl start natfrp.service
sudo systemctl enable natfrp.service
sudo systemctl status natfrp.service

echo -e "\e[32mSakuraFrp启动器安装完成。您可执行"systemctl status natfrp.service"查看服务状态\033[0m"
echo -e "\e[32m如果启动正常,请登录远程管理界面进行进一步配置。\033[0m"