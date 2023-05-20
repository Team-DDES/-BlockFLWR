import warnings
from collections import OrderedDict

import sys
sys.path.insert(0, '/media/hdd1/es_workspace/D-DES/src/py')

import flwr as fl
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision.datasets import CIFAR10
from torchvision.transforms import Compose, Normalize, ToTensor
from tqdm import tqdm
from logging import DEBUG, INFO
from flwr.common.logger import log
from Cifar import Net as Cifar_Net
from Cifar import train as Cifar_train
from Cifar import test as Cifar_test
from Cifar import load_data as Cifar_load_data

from Mnist import Net as Mnist_Net
from Mnist import train as Mnist_train
from Mnist import test as Mnist_test
from Mnist import load_data as Mnist_load_data

# from PhysNet import PhysNet as PhysNet_Net
# from PhysNet import train as PhysNet_train
# from PhysNet import test as PhysNet_test
# from PhysNet import load_data as PhysNet_load_data


# num = 6
# add = "127.0.0.1:8083"
# cid = 0
# cont = "0x22Bde2a9138481A0D7851CAdDdc7084e4484aa52"
# cont_N ="0x3D1f27DcF2eECE6E6bFEb1B3bF7Aef8878304c4d"
# model = "Mnist"

# sys.argv = [num,add, cid, cont, cont_N,model]
print("TESTESTESTETE")
print(sys.argv)
print(sys.argv[2])
# #############################################################################
# 1. Regular PyTorch pipeline: nn.Module, train, test, and DataLoader
# #############################################################################

warnings.filterwarnings("ignore", category=UserWarning)
DEVICE = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

if sys.argv[4] == "Cifar":
    net = Cifar_Net().to(DEVICE)
    train_loader, test_loader = Cifar_load_data()
# elif sys.argv[5] == "Physnet":
#     net = PhysNet_Net().to(DEVICE)
#     train_loader, test_loader = PhysNet_load_data()
else:
    net = Mnist_Net().to(DEVICE)
    train_loader, test_loader = Mnist_load_data()


# #############################################################################
# 2. Federation of the pipeline with Flower
# #############################################################################

# Load model and data (simple CNN, CIFAR-10)

#sys[1] : server_address 127.0.0.1:8081
#sys[2] : client cid
# sys[3] : contract address
# sys[4] : token_address
# sys[5] : nft_address


# Define Flower client
class FlowerClient(fl.client.EthClient):
    def __init__(self,
                 cid: str,
                 model:torch.nn.Module
                 ):
        super(FlowerClient, self).__init__(cid,contract_address = sys.argv[3], model = model)
        self.net = net
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
        if sys.argv[4] == "Cifar":
            Cifar_train(net, train_loader, epochs=1)
        else:
            Mnist_train(net, train_loader, epochs=1)
        # else:
        #     PhysNet_train(net, train_loader, epochs=1)

        print('after model train')
        uploaded_cid = self.IPFSClient.add_model(self.net)
        print('IPFS upload done', uploaded_cid)
        tx = self.EthBase.addModelUpdate(uploaded_cid, training_round)
        self.EthBase.wait_for_tx(tx)
        print('Add Model done')
        return [uploaded_cid], len(train_loader.dataset), {}

    def evaluate(self, parameters, config):
        account = self.EthBase.address
        if sys.argv[4] == "Cifar":
            client_loss, client_accuracy = Cifar_test(net, test_loader)
        else:
            client_loss, client_accuracy = Mnist_test(net, test_loader)
        # else:
        #     client_loss, client_accuracy = PhysNet_test(net, test_loader)

        self.set_parameters(parameters)
        if sys.argv[4] == "Cifar":
            loss, accuracy = Cifar_test(net, test_loader)
        else: 
            loss, accuracy = Mnist_test(net, test_loader)
        # else:
        #     loss, accuracy = PhysNet_test(net, test_loader)
        # Transfer FLT Token
        return loss, len(test_loader.dataset), {"accuracy": accuracy, "account":account, "client_loss":client_loss, "client_acc":client_accuracy}


# Start Flower client
fl.client.start_eth_client(
    server_address=str(sys.argv[1]),
    client=FlowerClient(cid=str(sys.argv[2]),model=net),
)
# fl.client.start_eth_client(
#     server_address="127.0.0.1:8081",
#     client=FlowerClient(cid=1),
# )
