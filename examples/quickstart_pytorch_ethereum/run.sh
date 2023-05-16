#!/bin/bash
set -e
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/

## Download the CIFAR-10 dataset
#python -c "from torchvision.datasets import CIFAR10; CIFAR10('./data', download=True)"

echo "Starting server"
python3 server.py 8081 2 0xFdA559785801E5dAbdF28602d6121B1A66DFC953 0x9aa3B578E2169A9636a61bC8DeeffE517B0b8CD7 0xDaCfbbB5AaAb2035b47c32a59e3877994B5Fb179 &
sleep 3  # Sleep for 3s to give the server enough time to start
#
for i in `seq 0 1`; do
    echo "Starting client"
    python3 client.py 127.0.0.1:8081 $i 0xFdA559785801E5dAbdF28602d6121B1A66DFC953 0x9aa3B578E2169A9636a61bC8DeeffE517B0b8CD7 0xDaCfbbB5AaAb2035b47c32a59e3877994B5Fb179 &
done

# Enable CTRL+C to stop all background processes
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM
# Wait for all background processes to complete
wait
