#!/usr/bin/env bash

cat << EOF
###################################################################################
# 本脚本用于替换 yum repo，使用国内 yum 仓库，加速下载
# 要求：仅适用于 Linux CentOS 发行版本，并且环境必须已支持 yum 、lsb_release 命令
# @author: Zhang Peng
###################################################################################

EOF

echo -e "\n>>>>>>>>> 替换 yum repo 源"

# 备份
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

# 执行 lsb_release 命令，获取系统发行版本
# version=`lsb_release -r | awk '{print substr($2,1,1)}'` # 很多机器没有 lsb_release 命令
version=`cat /etc/redhat-release | awk '{print substr($4,1,1)}'`

cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

# 根据发型版本选择相应 yum 镜像
if [[ ${version} == 5 ]]; then
    # Cento5 已废弃，只能使用 http://vault.CentOS.org/ 替换，但由于是国外镜像，速度较慢
    wget -N https://gitee.com/turnon/linux-tutorial/raw/master/codes/linux/sys/yum/Centos-5.repo -O /etc/yum.repos.d/CentOS-Base.repo

    # 根据实际发型版本情况替换
    detailVersion=`lsb_release -r | awk '{print substr($2,1,3)}'`
    sed -i 's/$releasever/'"${detailVersion}"'/g' /etc/yum.repos.d/CentOS-Base.repo

    # 不替换下面的开关，可能会出现错误：Could not open/read repomd.xml
    sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/CentOS-Media.repo
elif [[ ${version} == 6 ]]; then
    wget -N https://gitee.com/turnon/linux-tutorial/raw/master/codes/linux/sys/yum/Centos-6.repo -O /etc/yum.repos.d/CentOS-Base.repo
elif [[ ${version} == 7 ]]; then
    wget -N https://gitee.com/turnon/linux-tutorial/raw/master/codes/linux/sys/yum/Centos-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
else
    echo -e "版本不支持，替换 yum repo 失败"
fi

# 更新缓存
yum clean all
yum makecache

echo -e "\n>>>>>>>>> 替换 yum repo 源成功"
