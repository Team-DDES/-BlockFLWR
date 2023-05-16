from typing import List, Tuple
import sys
sys.path.insert(0, '/media/hdd1/es_workspace/D-DES/src/py')

import flwr as fl
from flwr.common import Metrics
from flwr.server.client_manager import SimpleClientManager
from flwr.server.server import EthServer

# Define metric aggregation function
def weighted_average(metrics: List[Tuple[int, Metrics]]) -> Metrics:
    # Multiply accuracy of each client by number of examples used
    accuracies = [num_examples * m["accuracy"] for num_examples, m in metrics]
    examples = [num_examples for num_examples, _ in metrics]

    # Aggregate and return custom metric (weighted average)
    return {"accuracy": sum(accuracies) / sum(examples)}


# Define strategy
strategy = fl.server.strategy.FedAvg(evaluate_metrics_aggregation_fn=weighted_average)

client_manager = SimpleClientManager()
eth_server = EthServer(client_manager = client_manager,
                       contract_address=sys.argv[3],
                       token_address=sys.argv[4],
                       nft_address=sys.argv[5],
                       strategy = strategy)

# sys[1] : server address ex) 0.0.0.0:8081
# sys[2] : num_rounds
# sys[3] : contract address
# sys[4] : token_address
# sys[5] : nft_address



# Start Flower server
fl.server.start_server(
    server_address="0.0.0.0:"+str(sys.argv[1]), # server port is 8081, cause by ipfs address
    server = eth_server,
    config = fl.server.ServerConfig(num_rounds=int(sys.argv[2])),
    strategy=strategy,
)
