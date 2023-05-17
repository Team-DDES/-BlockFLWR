import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web3_provider/ethereum.dart';

class WalletConnectionManager{
  static final WalletConnectionManager sInstance = WalletConnectionManager._internal();

  factory WalletConnectionManager(){
    return sInstance;
  }WalletConnectionManager._internal();

  late Timer timer;
  void start() {
    const url = 'https://your-api-url.com';
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
      if(kIsWeb){
        if(ethereum == null){
          userController.walletConnect.value = false;
        }else{
          if(ethereum!.isConnected()){
            userController.walletConnect.value = true;
          }else{
            userController.walletConnect.value = false;
          }
        }
      }
    });
  }

  void dispose() {
    timer.cancel();
  }
}