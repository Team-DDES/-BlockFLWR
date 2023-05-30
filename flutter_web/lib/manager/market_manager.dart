import 'package:flutter_web/data/market.dart';
import 'package:flutter_web/services/marketService.dart';
import 'package:get/get.dart';

class MarketManager{
  static final MarketManager sInstance = MarketManager._internal();

  factory MarketManager(){
    return sInstance;
  }MarketManager._internal();

  RxList<Market> marketList = <Market>[].obs;

  void initNFTList() async {
    MarketService nftService = MarketService();
    marketList.value = await nftService.getNFTList();
    print("Market List :: " + marketList.value.length.toString());
    return;
  }
}