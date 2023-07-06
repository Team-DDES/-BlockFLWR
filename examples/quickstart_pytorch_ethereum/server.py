from typing import List, Tuple
import sys
sys.path.insert(0, '/media/hdd1/es_workspace/D-DES/src/py')

import flwr as fl
from flwr.common import Metrics
from flwr.server.client_manager import SimpleClientManager
from flwr.server.server import EthServer


# from PhysNet import PhysNet as PhysNet_Net
from Mnist import Net as Mnist_Net
from Cifar import Net as Cifar_Net

# Define metric aggregation function
def weighted_average(metrics: List[Tuple[int, Metrics]]) -> Metrics:
    # Multiply accuracy of each client by number of examples used
    accuracies = [num_examples * m["accuracy"] for num_examples, m in metrics]
    examples = [num_examples for num_examples, _ in metrics]

    # Aggregate and return custom metric (weighted average)
    return {"accuracy": sum(accuracies) / sum(examples)}

num = 6
add = "0.0.0.0:8083"
round = 2
cont = "0xAE5eDc7e51c3dd6f3c2A92c6F1681589E814f82f"
model = "Mnist"
sys.argv = [num,add, round, cont, model]
# print(sys.argv)
strategy = fl.server.strategy.FedAvg(evaluate_metrics_aggregation_fn=weighted_average)

if sys.argv[4] == "Cifar":
    model = Cifar_Net()
# elif sys.argv[5] == "PhysNet":
#     model = PhysNet_Net()
else:
    model = Mnist_Net()

client_manager = SimpleClientManager()
eth_server = EthServer(client_manager = client_manager,
                       contract_address=sys.argv[3],
                       model=model,
                       strategy = strategy)


# Start Flower server
fl.server.start_server(
    server_address=str(sys.argv[1]), # server port is 8081, cause by ipfs address
    # server_address="0.0.0.0:"+"8081", # server port is 8081, cause by ipfs address
    server = eth_server,
    config = fl.server.ServerConfig(num_rounds=int(sys.argv[2])),
    strategy=strategy,
)
