DDES (Decentralized & Data Encryption System)


### python setting

1. make requirements.txt
```
vi requirements.txt
```
and write  with the content below
```
absl-py==1.4.0
aiohttp==3.8.3
aiosignal==1.3.1
asttokens==2.2.1
async-timeout==4.0.2
attrs==19.3.0
Automat==0.8.0
Babel==2.6.0
backcall==0.2.0
base58==2.1.1
bcrypt==3.1.7
beautifulsoup4==4.8.2
bitarray==2.6.0
blinker==1.4
bottle==0.12.15
Brlapi==0.7.0
cachetools==5.3.0
certifi==2019.11.28
chardet==3.0.4
charset-normalizer==2.1.1
chrome-gnome-shell==0.0.0
Click==7.0
cloud-init==23.1.2
colorama==0.4.3
command-not-found==0.3
configobj==5.0.6
constantly==15.1.0
contourpy==1.0.7
cryptography==2.8
cupshelpers==1.0
cycler==0.10.0
cytoolz==0.12.0
dbus-python==1.2.16
debtcollector==2.0.0
decorator==5.1.1
defer==1.0.6
distro==1.4.0
docker==4.1.0
docutils==0.16
dotenv-cli==2.0.1
duplicity==0.8.12.0
entrypoints==0.3
eth-abi==2.2.0
eth-account==0.5.9
eth-hash==0.3.3
eth-keyfile==0.5.1
eth-keys==0.3.4
eth-rlp==0.2.1
eth-typing==2.3.0
eth-utils==1.10.0
executing==1.2.0
fasteners==0.14.1
fonttools==4.38.0
frozenlist==1.3.3
future==0.18.2
gitdb==4.0.10
GitPython==3.1.31
Glances==3.1.3
google-auth==2.16.1
google-auth-oauthlib==0.4.6
grpcio==1.51.3
h5py==2.10.0
hexbytes==0.3.0
html5lib==1.0.1
httplib2==0.14.0
hyperlink==19.0.0
idna==2.8
imageio==2.28.1
importlib-metadata==6.0.0
importlib-resources==5.12.0
incremental==16.10.1
influxdb==5.2.0
ipfshttpclient==0.8.0a2
ipython==8.10.0
iso8601==0.1.12
iterators==0.2.0
jedi==0.18.2
Jinja2==2.10.1
joblib==1.2.0
jsonpatch==1.22
jsonpointer==2.0
jsonschema==3.2.0
keyring==18.0.1
keystoneauth1==4.0.0
kiwisolver==1.0.1
language-selector==0.1
launchpadlib==1.10.13
lazr.restfulclient==0.14.2
lazr.uri==1.0.3
linecache2==1.0.0
lockfile==0.12.2
louis==3.12.0
lru-dict==1.1.8
lxml==4.5.0
macaroonbakery==1.3.1
Mako==1.1.0
Markdown==3.4.1
MarkupSafe==2.1.2
mat73==0.59
matplotlib==3.1.2
matplotlib-inline==0.1.6
monotonic==1.5
more-itertools==4.2.0
msgpack==0.6.2
multiaddr==0.0.9
multidict==6.0.3
netaddr==0.7.19
netifaces==0.10.4
networkx==3.1
nodeenv==0.13.4
numpy==1.22.0
nvidia-cublas-cu11==11.10.3.66
nvidia-cuda-nvrtc-cu11==11.7.99
nvidia-cuda-runtime-cu11==11.7.99
nvidia-cudnn-cu11==8.5.0.96
oauthlib==3.1.0
olefile==0.46
opencv-python==4.5.2.54
os-service-types==1.7.0
oslo.config==8.0.2
oslo.context==3.0.2
oslo.i18n==4.0.1
oslo.log==4.1.1
oslo.serialization==3.1.1
oslo.utils==4.1.1
packaging==23.0
pandas==1.1.5
paramiko==2.6.0
parsimonious==0.8.1
parso==0.8.3
pbr==5.4.5
pexpect==4.6.0
pickleshare==0.7.5
Pillow==9.4.0
ply==3.11
prompt-toolkit==3.0.37
protobuf==4.22.0
psutil==5.5.1
pure-eval==0.2.2
pyasn1==0.4.2
pyasn1-modules==0.2.1
pycairo==1.16.2
pycryptodome==3.16.0
pycryptodomex==3.6.1
pycups==1.9.73
Pygments==2.14.0
PyGObject==3.36.0
PyHamcrest==1.9.0
pyinotify==0.9.6
PyJWT==1.7.1
pymacaroons==0.13.0
PyNaCl==1.3.0
pyOpenSSL==19.0.0
pyparsing==2.4.6
pyRFC3339==1.1
pyrsistent==0.15.5
pyserial==3.4
pysmi==0.3.2
pysnmp==4.4.6
pystache==0.5.4
python-apt==2.0.1+ubuntu0.20.4.1
python-dateutil==2.7.3
python-debian===0.1.36ubuntu1
python-dotenv==1.0.0
python-keystoneclient==4.0.0
python-swiftclient==3.9.0
pytz==2022.7.1
PyWavelets==1.4.1
pyxdg==0.26
PyYAML==6.0
requests==2.28.2
requests-oauthlib==1.3.1
requests-unixsocket==0.2.0
rfc3986==1.3.2
rlp==2.0.1
roman==2.0.0
rsa==4.9
scikit-image==0.17.2
scikit-learn==1.0.2
scipy==1.5.2
screen-resolution-extra==0.0.0
seaborn==0.12.2
SecretStorage==2.3.1
service-identity==18.1.0
simplejson==3.16.0
six==1.14.0
smmap==5.0.0
sos==4.4
soupsieve==1.9.5
ssh-import-id==5.10
stack-data==0.6.2
stevedore==1.32.0
system-service==0.3
systemd-python==234
tensorboard==2.12.0
tensorboard-data-server==0.7.0
tensorboard-plugin-wit==1.8.1
tensorboardX==2.4.1
testresources==2.0.0
thop==0.1.1.post2209072238
threadpoolctl==3.1.0
tifffile==2023.4.12
toolz==0.12.0
torch==1.13.1
torchvision==0.14.1
tqdm==4.64.0
traceback2==1.4.0
traitlets==5.9.0
Twisted==18.9.0
typing_extensions==4.5.0
ubuntu-advantage-tools==8001
ubuntu-drivers-common==0.0.0
ufw==0.36
unittest2==1.1.0
urllib3==1.25.8
usb-creator==0.3.7
varint==1.0.2
wadllib==1.3.3
wcwidth==0.2.6
web3==5.31.3
webencodings==0.5.1
websocket-client==0.53.0
websockets==9.1
Werkzeug==2.2.3
wrapt==1.11.2
xkit==0.0.0
yacs==0.1.8
yarl==1.8.2
zipp==3.15.0
zope.interface==4.7.1
```

2. install requirements.txt
pip install -r requirements.txt

3. check python path

```
which python
```

4. (optional) if python path isn't `/usr/local/bin/python3`

`vim ~/.profile`

export PATH=[ YOUR PYTHON PATH ]: $PATH

and save

`source ~/.profile`

### ipfs & web3 setting

`truffle` installation is required to build Solidity.

```shell
npm i -g truffle
```

And then, `ipfs daemon` installation is required to save deep learning model history. before installation must install nvm.
```shell
wget https://dist.ipfs.tech/kubo/v0.15.0/kubo_v0.12.2_linux-amd64.tar.gz
tar -xvzf kubo_v0.12.2_linux-amd64.tar.gz
cd kubo
sudo bash install.sh
```


## Front / Backend less scenario

First, run ipfs daemon to store the Deep Learning Network
```shell
ipfs daemon
```
Second, Run Ganache-cli at ddes/src/py/flwr/client/eth_client
```shell
truffle migrate --network mumbai --reset
```
After deployment, you can get the result like below.
```shell
2_deploy_contracts.js
=====================

   Replacing 'Crowdsource'
   -----------------------
   > transaction hash:    0x5e05aae436f07591464a11a0ba301220575038e8ff77cb6705401d521940aa5c
   > Blocks: 0            Seconds: 0
   > contract address:    0xCfEB869F69431e42cdB54A4F4f105C19C080A601
   > block number:        3
   > block timestamp:     1682418499
   > account:             0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1
   > balance:             99.95304242
   > gas used:            2103520 (0x2018e0)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.0420704 ETH
```

If you modify `CONTRACT_ADDRESS` of at `exapmles/quickstart_pytorch_ethereum/client.py ` and `server.py`'s sys.argv[4]


Now you are ready to start the Flower clients which will participate in the learning. To do so simply open two more terminal windows and run the following commands.

Start client 1 in the first terminal with cid 0:

```shell
python3 client.py
```

Start client 2 in the second terminal with cid 1:

```shell
python3 client.py
```


