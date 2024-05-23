#!/bin/bash

#Download the ubi-task parameter
if [ -z "$PARENT_PATH" ]; then
    echo "PARENT_PATH is empty. Skipping ubi-task parameter download."
else
    if [[ "$(lscpu | grep "Vendor ID" | awk '{print $3}')" == "AuthenticAMD" ]]; then
        docker run -e IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/ -e FIL_PROOFS_PARAMETER_CACHE=/var/tmp/filecoin-proof-parameters --rm -v "$PARENT_PATH":/var/tmp/filecoin-proof-parameters filswan/lotus-shed-amd:latest lotus-shed fetch-params --proving-params 512MiB
    else
        docker run -e IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/ -e FIL_PROOFS_PARAMETER_CACHE=/var/tmp/filecoin-proof-parameters --rm -v "$PARENT_PATH":/var/tmp/filecoin-proof-parameters filswan/lotus-shed-intel:latest lotus-shed fetch-params --proving-params 512MiB
    fi
fi
