#!/bin/bash

# 网段的基础部分
network="192.168.0"

# 使用函数执行ping并检查结果
function check_ip() {
    local ip=$1
    ping -c 1 -W 1 $ip > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$ip is up"
    fi
}

# 从1到254扫描整个网段
for ip in $(seq 2 100); do
    check_ip $network.$ip &
done

# 等待所有后台进程完成
wait
