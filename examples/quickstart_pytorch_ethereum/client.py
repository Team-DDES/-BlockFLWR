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

import sys

num = 6
add = "127.0.0.1:8083"
cid = 1
cont = "0x9CBa1cF5f96FDbd0242dCb7B3cBa6C136F16Ba30"
cont_N ="0x438b06ab7B23EC536C2Eb292F449B490069D0A64"


sys.argv = [num,add, cid, cont, cont_N]

# #############################################################################
# 1. Regular PyTorch pipeline: nn.Module, train, test, and DataLoader
# #############################################################################

warnings.filterwarnings("ignore", category=UserWarning)
DEVICE = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")


class Net(nn.Module):
    """Model (simple CNN adapted from 'PyTorch: A 60 Minute Blitz')"""

    def __init__(self) -> None:
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(-1, 16 * 5 * 5)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        return self.fc3(x)


def train(net, trainloader, epochs):
    """Train the model on the training set."""
    criterion = torch.nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(net.parameters(), lr=0.001, momentum=0.9)
    for _ in range(epochs):
        for images, labels in tqdm(trainloader):
            optimizer.zero_grad()
            criterion(net(images.to(DEVICE)), labels.to(DEVICE)).backward()
            optimizer.step()


def test(net, testloader):
    """Validate the model on the test set."""
    criterion = torch.nn.CrossEntropyLoss()
    correct, loss = 0, 0.0
    with torch.no_grad():
        for images, labels in tqdm(testloader):
            outputs = net(images.to(DEVICE))
            labels = labels.to(DEVICE)
            loss += criterion(outputs, labels).item()
            correct += (torch.max(outputs.data, 1)[1] == labels).sum().item()
    accuracy = correct / len(testloader.dataset)
    return loss, accuracy


def load_data():
    """Load CIFAR-10 (training and test set)."""
    trf = Compose([ToTensor(), Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])
    trainset = CIFAR10("./data", train=True, download=True, transform=trf)
    testset = CIFAR10("./data", train=False, download=True, transform=trf)
    return DataLoader(trainset, batch_size=32, shuffle=True), DataLoader(testset)


# #############################################################################
# 2. Federation of the pipeline with Flower
# #############################################################################

# Load model and data (simple CNN, CIFAR-10)
net = Net().to(DEVICE)
trainloader, testloader = load_data()

#sys[1] : server_address 127.0.0.1:8081
#sys[2] : client cid
# sys[3] : contract address
# sys[4] : token_address
# sys[5] : nft_address


# Define Flower client
class FlowerClient(fl.client.EthClient):
    def __init__(self,
                 cid: str,
                 ):
        super(FlowerClient, self).__init__(cid,contract_address = sys.argv[3],nft_address = sys.argv[4])
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
        train(net, trainloader, epochs=1)
        print('after model train')
        uploaded_cid = self.IPFSClient.add_model(self.net)
        print('IPFS upload done',uploaded_cid)
        tx = self.EthBase.addModelUpdate(uploaded_cid, training_round)
        self.EthBase.wait_for_tx(tx)
        print('Add Model done')
        return [uploaded_cid], len(trainloader.dataset), {}

    def evaluate(self, parameters, config):
        account = self.EthBase.address
        client_loss, client_accuracy = test(net, testloader)
        self.set_parameters(parameters)
        loss, accuracy = test(net, testloader)
        log(INFO,"accuracy: %s",accuracy)
        # Transfer FLT Token
        return loss, len(testloader.dataset), {"accuracy": accuracy, "account":account, "client_loss":client_loss, "client_acc":client_accuracy}


# Start Flower client
fl.client.start_eth_client(
    server_address=str(sys.argv[1]),
    client=FlowerClient(cid=str(sys.argv[2])),
)
# fl.client.start_eth_client(
#     server_address="127.0.0.1:8081",
#     client=FlowerClient(cid=1),
# )
