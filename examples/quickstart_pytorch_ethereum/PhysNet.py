import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision.datasets import CIFAR10
from torchvision.transforms import Compose, Normalize, ToTensor
from tqdm import tqdm
import numpy as np
from torch.utils.data import Dataset
import torchvision.transforms as transforms
import cv2
import scipy
from scipy.signal import butter
from scipy.sparse import spdiags
import h5py

DEVICE = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

class PhysNet(torch.nn.Module):
    def __init__(self, frames=32):
        super(PhysNet, self).__init__()
        self.physnet = torch.nn.Sequential(
            EncoderBlock(),
            decoder_block(),
            torch.nn.AdaptiveMaxPool3d((frames, 1, 1)),  # spatial adaptive pooling
            torch.nn.Conv3d(64, 1, [1, 1, 1], stride=1, padding=0)
        )

    def forward(self, x):
        [batch, channel, length, width, height] = x.shape
        return self.physnet(x).view(-1, length)


class EncoderBlock(torch.nn.Module):
    def __init__(self):
        super(EncoderBlock, self).__init__()
        #, in_channel, out_channel, kernel_size, stride, padding
        self.encoder_block = torch.nn.Sequential(
            ConvBlock3D(3, 16, [1, 5, 5], [1, 1, 1], [0, 2, 2]),
            torch.nn.MaxPool3d((1, 2, 2), stride=(1, 2, 2)),
            ConvBlock3D(16, 32, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            ConvBlock3D(32, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            torch.nn.MaxPool3d((2, 2, 2), stride=(2, 2, 2)),  # Temporal Halve
            ConvBlock3D(64, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            ConvBlock3D(64, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            torch.nn.MaxPool3d((2, 2, 2), stride=(2, 2, 2)),  # Temporal Halve
            ConvBlock3D(64, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            ConvBlock3D(64, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            torch.nn.MaxPool3d((1, 2, 2), stride=(1, 2, 2)),
            ConvBlock3D(64, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
            ConvBlock3D(64, 64, [3, 3, 3], [1, 1, 1], [1, 1, 1]),
        )

    def forward(self, x):
        return self.encoder_block(x)

class decoder_block(torch.nn.Module):
    def __init__(self):
        super(decoder_block, self).__init__()
        self.decoder_block = torch.nn.Sequential(
            DeConvBlock3D(64, 64, [4, 1, 1], [2, 1, 1], [1, 0, 0]),
            DeConvBlock3D(64, 64, [4, 1, 1], [2, 1, 1], [1, 0, 0])
        )

    def forward(self, x):
        return self.decoder_block(x)

class DeConvBlock3D(torch.nn.Module):
    def __init__(self, in_channel, out_channel, kernel_size, stride, padding):
        super(DeConvBlock3D, self).__init__()
        self.deconv_block_3d = torch.nn.Sequential(
            torch.nn.ConvTranspose3d(in_channel, out_channel, kernel_size, stride, padding),
            torch.nn.BatchNorm3d(out_channel),
            torch.nn.ELU()
        )

    def forward(self, x):
        return self.deconv_block_3d(x)

class ConvBlock3D(torch.nn.Module):
    def __init__(self, in_channel, out_channel, kernel_size, stride, padding):
        super(ConvBlock3D, self).__init__()
        self.conv_block_3d = torch.nn.Sequential(
            torch.nn.Conv3d(in_channel, out_channel, kernel_size, stride, padding),
            torch.nn.BatchNorm3d(out_channel),
            torch.nn.ReLU(inplace=True)
        )

    def forward(self, x):
        return self.conv_block_3d(x)


class NegPearsonLoss(nn.Module):
    def __init__(self):
        super(NegPearsonLoss, self).__init__()

    def forward(self, predictions, targets):
        return neg_Pearson_Loss(predictions, targets)


def neg_Pearson_Loss(predictions, targets):
    '''
    :param predictions: inference value of trained model
    :param targets: target label of input data
    :return: negative pearson loss
    '''
    rst = 0
    targets = targets[:, :]
    predictions = torch.squeeze(predictions)
    # Pearson correlation can be performed on the premise of normalization of input data
    predictions = (predictions - torch.mean(predictions)) / torch.std(predictions)
    targets = (targets - torch.mean(targets)) / torch.std(targets)

    for i in range(predictions.shape[0]):
        sum_x = torch.sum(predictions[i])  # x
        sum_y = torch.sum(targets[i])  # y
        sum_xy = torch.sum(predictions[i] * targets[i])  # xy
        sum_x2 = torch.sum(torch.pow(predictions[i], 2))  # x^2
        sum_y2 = torch.sum(torch.pow(targets[i], 2))  # y^2
        N = predictions.shape[1] if len(predictions.shape) > 1 else 1
        pearson = (N * sum_xy - sum_x * sum_y) / (
            torch.sqrt((N * sum_x2 - torch.pow(sum_x, 2)) * (N * sum_y2 - torch.pow(sum_y, 2))))

        rst += 1 - pearson

    rst = rst / predictions.shape[0]
    return rst

def train(net, trainloader, epochs):
    """Train the model on the training set."""
    criterion = neg_Pearson_Loss()
    optimizer = torch.optim.Adam(net.parameters(), lr = 0.001)
    for _ in range(epochs):
        for images, labels in tqdm(trainloader):
            optimizer.zero_grad()
            criterion(net(images.to(DEVICE)), labels.to(DEVICE)).backward()
            optimizer.step()

def detrend(signal, Lambda):
    """detrend(signal, Lambda) -> filtered_signal
    This function applies a detrending filter.
    This  is based on the following article "An advanced detrending method with application
    to HRV analysis". Tarvainen et al., IEEE Trans on Biomedical Engineering, 2002.
    *Parameters*
      ``signal`` (1d numpy array):
        The signal where you want to remove the trend.
      ``Lambda`` (int):
        The smoothing parameter.
    *Returns*
      ``filtered_signal`` (1d numpy array):
        The detrended signal.
    """
    signal_length = len(signal)

    # observation matrix
    H = np.identity(signal_length)

    # second-order difference matrix

    ones = np.ones(signal_length)
    minus_twos = -2 * np.ones(signal_length)
    diags_data = np.array([ones, minus_twos, ones])
    diags_index = np.array([0, 1, 2])
    D = spdiags(diags_data, diags_index, (signal_length - 2), signal_length).toarray()
    filtered_signal = np.dot((H - np.linalg.inv(H + (Lambda ** 2) * np.dot(D.T, D))), signal)
    return filtered_signal

def BPF(input_val, fs=30,low= 0.75, high=2.5):
    low = low / (0.5 * fs)
    high = high / (0.5 * fs)
    [b_pulse, a_pulse] = butter(1, [low, high], btype='bandpass')
    return scipy.signal.filtfilt(b_pulse, a_pulse, np.double(input_val))

def _next_power_of_2(x):
    """Calculate the nearest power of 2."""
    return 1 if x == 0 else 2 ** (x - 1).bit_length()


def calculate_hr(cal_type, ppg_signal, fs=60, low_pass=0.75, high_pass=2.5):
    """Calculate heart rate based on PPG using Fast Fourier transform (FFT)."""
    if cal_type == "FFT":
        ppg_signal = np.expand_dims(ppg_signal, 0)
        N = _next_power_of_2(ppg_signal.shape[1])
        f_ppg, pxx_ppg = scipy.signal.periodogram(ppg_signal, fs=fs, nfft=N, detrend=False)
        fmask_ppg = np.argwhere((f_ppg >= low_pass) & (f_ppg <= high_pass))
        mask_ppg = np.take(f_ppg, fmask_ppg)
        mask_pxx = np.take(pxx_ppg, fmask_ppg)
        hr = np.take(mask_ppg, np.argmax(mask_pxx, 0))[0] * 60
    else:
        ppg_peaks, _ = scipy.signal.find_peaks(ppg_signal)
        hr = 60 / (np.mean(np.diff(ppg_peaks)) / fs)
    return hr

def get_hr(pred, label, model_type, cal_type, fs=30, bpf_flag=True,low =0.75,high=2.5):
    if model_type == "DIFF":
        pred = detrend(np.cumsum(pred),100)
        label = detrend(np.cumsum(label),100)
    else:
        pred = detrend(pred,100)
        label = detrend(label,100)

    if bpf_flag:
        pred = BPF(pred,fs,low,high)
        label = BPF(pred,fs,low,high)

    if cal_type != "BOTH":
        hr_pred = [calculate_hr(cal_type,p,fs,low,high) for p in pred]
        hr_label = [calculate_hr(cal_type,l,fs,low,high) for l in label]
    else:
        hr_pred_fft = calculate_hr("FFT", pred, fs, low, high)
        hr_label_fft = calculate_hr("FFT", label, fs, low, high)
        hr_pred_peak = calculate_hr("PEAK", pred, fs, low, high)
        hr_label_peak = calculate_hr("PEAK", label, fs, low, high)
        hr_pred = [hr_pred_fft,hr_pred_peak]
        hr_label = [hr_label_fft, hr_label_peak]

    return hr_pred, hr_label

def MAE(pred,label):
    return np.mean(np.abs(pred-label))

def test(net, testloader):
    """Validate the model on the test set."""
    criterion = neg_Pearson_Loss()
    correct, loss = 0, 0.0
    hr_preds = []
    hr_targets = []
    with torch.no_grad():
        for images, labels in tqdm(testloader):
            outputs = net(images.to(DEVICE))
            labels = labels.to(DEVICE)
            loss += criterion(outputs, labels).item()
            hr_pred, hr_target = get_hr(outputs.detach().cpu().numpy(), labels.detach().cpu().numpy(),
                                        model_type='cont', cal_type='FFT')
            hr_preds.extend(hr_pred)
            hr_targets.extend(hr_target)
        hr_preds = np.asarray(hr_preds)
        hr_targets = np.asarray(hr_targets)
    accuracy = MAE(hr_preds,hr_targets)
    return loss, accuracy


class PhysNetDataset(Dataset):
    def __init__(self, video_data, label_data,target_length):
        self.transform = transforms.Compose([transforms.ToTensor()])
        self.video_data = np.reshape(video_data,(-1,target_length,32,32,3))
        self.label_data = np.reshape(label_data,(-1,target_length))

    def __getitem__(self, index):
        if torch.is_tensor(index):
            index = index.tolist()

        video_data = torch.tensor(np.transpose(self.video_data[index], (3, 0, 1, 2)), dtype=torch.float32)
        label_data = torch.tensor(self.label_data[index], dtype=torch.float32)

        if torch.cuda.is_available():
            video_data = video_data.to('cuda')
            label_data = label_data.to('cuda')

        return video_data, label_data

    def __len__(self):
        return len(self.label_data)

def normalize(arr, t_min, t_max):
    norm_arr = []
    diff = t_max - t_min
    diff_arr = max(arr) - min(arr)
    for i in arr:
        tmp = (((i - min(arr) * diff) / diff_arr)) + t_min
        norm_arr.append(tmp)

    return norm_arr


def load_h5y(file_name, time_length = 128, img_size=128, overlap_interval = 32):
    file = h5py.File(file_name)
    start = 0
    end = time_length
    # label = detrend(file['preprocessed_label'], 100)
    label = file['preprocessed_label']
    num_frame, w, h, c = file['raw_video'][:].shape

    video_data = []
    label_data = []

    if len(label) != num_frame:
        label = np.interp(
            np.linspace(
                1, len(label), num_frame), np.linspace(
                1, len(label), len(label)), label)

    if w != img_size:
        new_shape = (num_frame, img_size, img_size, c)
        resized_img = np.zeros(new_shape)
        for i in range(num_frame):
            img = file['raw_video'][i] / 255.0
            resized_img[i] = cv2.resize(img, (img_size, img_size))

    while end <= len(file['raw_video']):
        if w != img_size:
            video_chunk = resized_img[start:end]
        else:
            video_chunk = file['raw_video'][start:end]
        # min_val = np.min(video_chunk, axis=(0, 1, 2), keepdims=True)
        # max_val = np.max(video_chunk, axis=(0, 1, 2), keepdims=True)
        # video_chunk = (video_chunk - min_val) / (max_val - min_val)
        video_data.append(video_chunk)
        tmp_label = label[start:end]

        tmp_label = np.around(normalize(tmp_label, 0, 1), 2)
        label_data.append(tmp_label)
        # video_chunks.append(video_chunk)
        start += time_length - overlap_interval
        end += time_length - overlap_interval

    return video_data, label_data


def load_data():

    time_length = 128

    train_video, train_label =load_h5y("./1.h5")
    test_video, test_label =load_h5y("./2.h5")
    trainset = PhysNetDataset(train_video,train_label,time_length)
    testset = PhysNetDataset(test_video,test_label,time_length)

    return DataLoader(trainset, batch_size=32, shuffle=True), DataLoader(testset, batch_size=32)