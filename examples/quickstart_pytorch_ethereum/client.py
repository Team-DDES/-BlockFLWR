import sys
import warnings
from collections import OrderedDict
from logging import INFO

import torch

import flwr as fl
from flwr.common.logger import log
from . import *

# #############################################################################
# 1. Regular PyTorch pipeline: nn.Module, train, test, and DataLoader
# #############################################################################

warnings.filterwarnings("ignore", category=UserWarning)
DEVICE = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

if sys.argv[6] == "Cifar":
    net = Cifar_Net().to(DEVICE)
    train_loader, test_loader = Cifar_load_data()
# elif sys.argv[6] == "Physnet":
else:
    net = PhysNet().to(DEVICE)
    train_loader, test_laoder = PhysNet_load_data()


# #############################################################################
# 2. Federation of the pipeline with Flower
# #############################################################################

# Load model and data (simple CNN, CIFAR-10)

# sys[1] : server_address 127.0.0.1:8081
# sys[2] : client cid
# sys[3] : contract address
# sys[4] : token_address
# sys[5] : nft_address
# sys[6] : model type
# sys.argv[1] = "127.0.0.1:8081"
# sys.argv[2] = 0
# sys.argv[3] = contract address
# sys.argv[4] = token_address
# sys.argv[5] = nft_address
# sys.argv[6] = "Cifar"





# Define Flower client
class FlowerClient(fl.client.EthClient):
    def __init__(self,
                 cid: str,
                 ):
        super(FlowerClient, self).__init__(cid, sys.argv[3], sys.argv[4], sys.argv[5])

        self.net = net
        self.IPFSClient.set_model(net)
        self.initial_setting()

    def get_parameters(self, config):
        return [val.cpu().numpy() for _, val in net.state_dict().items()]

    def set_parameters(self, parameters):
        params_dict = zip(net.state_dict().keys(), parameters)
        state_dict = OrderedDict({k: torch.tensor(v) for k, v in params_dict})
        net.load_state_dict(state_dict, strict=True)

    def fit(self, config):
        print("Client FIT @ eth_client")
        training_round = self.EthBase.currentRound()
        print("training_round", training_round)
        if training_round == 1:
            g_model_cid = self.EthBase.getGenesis()
        else:
            g_model_cid = self.EthBase.getGlobalmodel(training_round)
        print("g_model_cid", g_model_cid)
        net = self.IPFSClient.get_model(g_model_cid)
        # self.set_parameters(parameters)
        if sys.argv[6] == "Cifar":
            Cifar_train(net, train_loader, epochs=1)
        elif sys.argv[6] == "Mnist":
            Mnist_train(net, train_loader, epochs=1)
        else:
            PhysNet_train(net, train_loader, epochs=1)

        print('after model train')
        uploaded_cid = self.IPFSClient.add_model(self.net)
        print('IPFS upload done', uploaded_cid)
        tx = self.EthBase.addModelUpdate(uploaded_cid, training_round)
        self.EthBase.wait_for_tx(tx)
        print('Add Model done')
        return [uploaded_cid], len(train_loader.dataset), {}

    def evaluate(self, parameters, config):
        self.set_parameters(parameters)
        if sys.argv[6] == "Cifar":
            loss, accuracy = Cifar_test(net, test_loader, epochs=1)
        elif sys.argv[6] == "Mnist":
            loss, accuracy = Mnist_test(net, test_loader, epochs=1)
        else:
            loss, accuracy = PhysNet_tset(net, test_loader, epochs=1)
        log(INFO, "accuracy: %s", accuracy)
        return loss, len(test_loader.dataset), {"accuracy": accuracy}


# Start Flower client
fl.client.start_eth_client(
    server_address=sys.argv[1],
    client=FlowerClient(cid=sys.argv[2]),
)
# fl.client.start_eth_client(
#     server_address="127.0.0.1:8081",
#     client=FlowerClient(cid=1),
# )
