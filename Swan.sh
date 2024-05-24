#!/bin/bash

read -p "请输入 ECP IP 地址: " ECP_IP

ECP_PORT=9085

read -p "请输入自定义 ECP 节点名称: " node_name

read -p "请输入你的密钥 (不能带 0x 开头): " private_key
if [[ $private_key == 0x* ]]; then
  echo "密钥不能带 0x 开头"
  exit 1
fi
echo $private_key > private.key

read -p "请输入你的钱包地址: " wallet_address

cat >> /etc/profile <<EOF
export ECP_IP=$ECP_IP
export ECP_PORT=$ECP_PORT
export PARENT_PATH="/root/swan"
export FIL_PROOFS_PARAMETER_CACHE=\$PARENT_PATH
EOF

source /etc/profile

curl -fsSL https://raw.githubusercontent.com/Minusbill/swan/main/fetch-param-512.sh | bash

curl -fsSL https://raw.githubusercontent.com/Minusbill/swan/main/fetch-param-32.sh | bash

wget https://github.com/swanchain/go-computing-provider/releases/download/v0.4.7/computing-provider

chmod +x computing-provider

./computing-provider init --multi-address=/ip4/$ECP_IP/tcp/$ECP_PORT --node-name=$node_name

./computing-provider wallet import private.key

./computing-provider account create --ownerAddress $wallet_address --ubi-flag=true

nohup ./computing-provider ubi daemon >> cp.log 2>&1 &

