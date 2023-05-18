#!/bin/bash
set -e
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/

ADD1="0x0dabd74C598Fc6348244BdB91998FEED1215A953"
ADD2="0x01E945fF6FC42C5ACF3A8C9bAE84d3A8e543B86f"
SERVER_CONNECT_ADDR="127.0.0.1:8081"
SERVER_AADR="0.0.0.0:8081"
MODEL="Cifar"

## Download the CIFAR-10 dataset
#python -c "from torchvision.datasets import CIFAR10; CIFAR10('./data', download=True)"

echo "Starting server"
python3 server.py $SERVER_AADR 2 $ADD1 $ADD2 $MODEL &
sleep 3  # Sleep for 3s to give the server enough time to start
#
for i in `seq 0 1`; do
    echo "Starting client"
    python3 client.py $SERVER_CONNECT_ADDR $i $ADD1 $ADD2 $MODEL &
done

# Enable CTRL+C to stop all background processes
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM
# Wait for all background processes to complete
wait
