#!/bin/bash

# 函数：检查错误并退出
check_error() {
    if [ $? -ne 0 ]; then
        echo "发生错误。退出..."
        exit 1
    fi
}

# 生成随机密码
generate_random_password() {
    echo $(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9!@#$%^&*()_-')
}

# 提示用户选择密码选项
echo "请选择密码选项："
echo "1. 生成密码"
echo "2. 输入密码"
read -p "请输入选项编号： " option

case $option in
    1)
        password=$(generate_random_password) # 保存生成的密码
        ;;
    2)
        read -p "请输入密码： " custom_password
        password=$custom_password # 保存输入的密码
        ;;
    *)
        echo "无效选项。退出..."
        exit 1
        ;;
esac

# 在 sshd_config 中启用 PermitRootLogin
sudo sed -i 's/^#?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
check_error

# 在 sshd_config 中启用 PasswordAuthentication
sudo sed -i 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
check_error

# 重启 SSHD 服务
sudo service sshd restart
check_error

echo "密码更改成功，请妥善保存密码。" # 提示用户保存密码

