from .Cifar import Net as Cifar_Net
from .Cifar import train as Cifar_train
from .Cifar import test as Cifar_test
from .Cifar import load_data as Cifar_load_data

from .PhysNet import PhysNet as PhysNet
from .PhysNet import train as PhysNet_train
from .PhysNet import test as PhysNet_tset
from .PhysNet import load_data as PhysNet_load_data

__all__ = [
    "Cifar_Net",
    "Cifar_train",
    "Cifar_test",
    "Cifar_load_data",
    "PhysNet",
    "PhysNet_train",
    "PhysNet_tset",
    "PhysNet_load_data"
]